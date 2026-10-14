/************************
 * File: video_driver.cpp
 *
 * Description: This file is the Lab 4 / Lab 5 driver. It loads the test frames, builds every
 *          test resolution, runs each experiment under the same measurement procedure,
 *          verifies outputs, saves image captures, and prints markdown tables to stdout (the
 *          Makefile tees stdout into outputs/).
 *
 *          Usage: ./video_driver <part1|part2|part3|part4|part5> [video]
 *                 ./video_driver lab5 <video> <current|lab2>
 *              part1 - baseline full-frame pipeline (cv::Mat::at)
 *              part2 - row-major vs. column-major traversal (no video needed)
 *              part3 - .at() vs. row-pointer pixel access
 *              part4 - data-movement analysis of the baseline pipeline
 *              part5 - three-row streaming pipeline + Part 6 measurements
 *              lab5  - Lab 5 compiler-optimization measurement of one implementation:
 *                      current = Lab 4 full-frame row-pointer pipeline
 *                      lab2    = Lab 2 baseline grayscale()/sobel() (grayscale_lab3/sobel_lab3)
 *                      The Makefile builds one binary per set of compiler flags.
 *
 *          Measured region: only the grayscale and Sobel function calls. Video decode,
 *          resizing, buffer allocation, image comparison, and PNG writes are all outside it.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <opencv2/opencv.hpp>
#include <algorithm>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "video_driver.hpp"
#include "memory_pipelines.hpp"
#include "compare.hpp"
#include "optimizations.hpp"
#include "traversal.hpp"
#include "cache_info.hpp"

// test resolutions (all 16:9, same content scaled from the 4K source)
struct Resolution {
    int width;
    int height;
};

static const Resolution RESOLUTIONS[] = {
    {320,  180},
    {640,  360},
    {1280, 720},
    {1920, 1080},
    {3840, 2160},
};

// the BENCH_FRAMES input frames at one resolution
struct FrameSet {
    int width;
    int height;
    std::vector<cv::Mat> rgb;
};

// pipeline identifiers used by the benchmark harness
enum PipelineId {
    PIPE_AT = 0,        // full gray frame, cv::Mat::at()
    PIPE_PTR = 1,       // full gray frame, row pointers
    PIPE_STREAM = 2,    // three gray rows, row pointers
    PIPE_LAB2 = 3       // Lab 2 baseline: 3-channel gray copy, new Sobel frame per call
};

static const char* PIPELINE_NAMES[] = {"Baseline (.at)", "Full-frame (ptr)", "Streaming (3 rows)",
                                       "Lab 2 baseline"};

// every preallocated buffer used by the three pipelines at one resolution
struct PipelineBuffers {
    cv::Mat gray_at, sobel_at;
    cv::Mat gray_ptr, sobel_ptr;
    cv::Mat row_buffers, sobel_stream;
    cv::Mat gray_lab2, sobel_lab2;      // CV_8UC3, Lab 2 baseline (Lab 5 only)
};

// per-frame timings of one pipeline (gray/sobel are empty for the fused streaming pipeline)
struct PipelineTimes {
    std::vector<double> gray_ms;
    std::vector<double> sobel_ms;
    std::vector<double> total_ms;
};

/*==========================================================================================
 * Helpers
 *========================================================================================*/

/******************************
 * Function: now_ms
 *
 * Description: This function returns a monotonic timestamp in milliseconds.
 *
 * return: double, steady_clock time in ms
 *
 ******************************/
static double now_ms(){
    return std::chrono::duration<double, std::milli>(
        std::chrono::steady_clock::now().time_since_epoch()).count();
}

/******************************
 * Function: median
 *
 * Description: This function returns the median of a list of times.
 *
 * param values: list of values (copied, then sorted)
 *
 * return: double, median value (0 if empty)
 *
 ******************************/
static double median(std::vector<double> values){
    if(values.empty()){return 0.0;}
    std::sort(values.begin(), values.end());
    return values[values.size() / 2];
}

/******************************
 * Function: res_name
 *
 * Description: This function formats a resolution as "WxH".
 *
 * param width: image width
 * param height: image height
 *
 * return: std::string, "WxH"
 *
 ******************************/
static std::string res_name(int width, int height){
    return std::to_string(width) + "x" + std::to_string(height);
}

/******************************
 * Function: capture_path
 *
 * Description: This function builds a capture file name, e.g.
 *  captures/part3_sobel_ptr_1280x720.png
 *
 * param part: part prefix, e.g. "part3"
 * param what: image description, e.g. "sobel_ptr"
 * param width: image width
 * param height: image height
 *
 * return: std::string, relative path of the capture
 *
 ******************************/
static std::string capture_path(const char* part, const char* what, int width, int height){
    return std::string(CAPTURE_DIR) + "/" + part + "_" + what + "_" + res_name(width, height) + ".png";
}

/******************************
 * Function: diff_string
 *
 * Description: This function formats a comparison result as markdown table cells.
 *
 * param diff: pointer to the comparison result
 *
 * return: std::string, "| differing | max diff | identical |"
 *
 ******************************/
static std::string diff_string(ImageDiff* diff){
    if(!diff->comparable){return "| n/a | n/a | NO (size/type mismatch) |";}
    return "| " + std::to_string(diff->differing_pixels) + " | " +
           std::to_string(diff->max_abs_diff) + " | " + (diff->identical ? "yes" : "NO") + " |";
}

/******************************
 * Function: load_frames
 *
 * Description: This function reads BENCH_FRAMES consecutive frames starting at
 *  START_FRAME, then scales them to every test resolution. All of this happens before
 *  any timing. Frame CAPTURE_INDEX of every FrameSet is the frame saved to captures/.
 *
 * param video_file: path to the input video
 * param sets: pointer to the output list of frame sets (one per resolution)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
static int load_frames(const char* video_file, std::vector<FrameSet>* sets){
    cv::VideoCapture cap(video_file);
    if(!cap.isOpened()){
        std::cout << "Error: couldn't open file: " << video_file << std::endl;
        return 0;
    }

    // use a later frame so the comparison is not taken from the black intro
    cap.set(cv::CAP_PROP_POS_FRAMES, START_FRAME);

    double fps = cap.get(cv::CAP_PROP_FPS);
    std::vector<cv::Mat> source;
    cv::Mat frame;
    for(int f = 0; f < BENCH_FRAMES; f++){
        if(!cap.read(frame)){
            std::cout << "Error: couldn't read frame " << START_FRAME + f << std::endl;
            return 0;
        }
        source.push_back(frame.clone());
    }
    cap.release();

    std::cout << "Input: " << video_file << " (" << res_name(source[0].cols, source[0].rows)
              << "), frames " << START_FRAME << "-" << START_FRAME + BENCH_FRAMES - 1
              << " (" << BENCH_FRAMES << " frames = " << std::fixed << std::setprecision(2)
              << BENCH_FRAMES / fps << " s of video at " << fps << " fps)"
              << ", scaled with cv::resize(INTER_AREA) before timing\n";

    // same content at every resolution
    for(const Resolution& res : RESOLUTIONS){
        FrameSet set;
        set.width = res.width;
        set.height = res.height;
        for(cv::Mat& src : source){
            cv::Mat scaled;
            // native resolution shares the decoded frame (read only) instead of copying it
            if(src.cols == res.width && src.rows == res.height){scaled = src;}
            else{cv::resize(src, scaled, cv::Size(res.width, res.height), 0, 0, cv::INTER_AREA);}
            set.rgb.push_back(scaled);
        }
        sets->push_back(set);
    }

    return 1;
}

/******************************
 * Function: allocate_buffers
 *
 * Description: This function allocates every pipeline buffer for one resolution. Called
 *  once per resolution, before the timed loop; the pipelines reuse these buffers.
 *
 * param buffers: pointer to the buffers to allocate
 * param width: image width
 * param height: image height
 *
 * return: none
 *
 ******************************/
static void allocate_buffers(PipelineBuffers* buffers, int width, int height){
    buffers->gray_at.create(height, width, CV_8UC1);
    buffers->sobel_at.create(height, width, CV_8UC1);
    buffers->gray_ptr.create(height, width, CV_8UC1);
    buffers->sobel_ptr.create(height, width, CV_8UC1);
    buffers->row_buffers.create(3, width, CV_8UC1);
    buffers->sobel_stream.create(height, width, CV_8UC1);
    // grayscale_lab3() copies into this with copyTo(), which reuses it when size/type match;
    // sobel_lab3() always allocates its own output frame (that is part of the Lab 2 code)
    buffers->gray_lab2.create(height, width, CV_8UC3);
}

/******************************
 * Function: run_pipeline_timed
 *
 * Description: This function runs one pipeline on one frame and appends its timings. Only
 *  the grayscale/Sobel calls are inside the timed region.
 *
 * param id: which pipeline to run
 * param rgb_frame: pointer to the input BGR frame
 * param buffers: pointer to the preallocated buffers
 * param times: pointer to the timing lists (nullptr = untimed warmup / verification run)
 *
 * return: none
 *
 ******************************/
static void run_pipeline_timed(int id, cv::Mat* rgb_frame, PipelineBuffers* buffers,
                               PipelineTimes* times){
    double t0 = 0, t1 = 0, t2 = 0;

    if(id == PIPE_AT){
        t0 = now_ms();
        grayscale_at(rgb_frame, &buffers->gray_at);
        t1 = now_ms();
        sobel_at(&buffers->gray_at, &buffers->sobel_at);
        t2 = now_ms();
    } else if(id == PIPE_PTR){
        t0 = now_ms();
        grayscale_ptr(rgb_frame, &buffers->gray_ptr);
        t1 = now_ms();
        sobel_ptr(&buffers->gray_ptr, &buffers->sobel_ptr);
        t2 = now_ms();
    } else if(id == PIPE_LAB2){
        t0 = now_ms();
        grayscale_lab3(rgb_frame, &buffers->gray_lab2);
        t1 = now_ms();
        cv::Mat* sobel_frame = sobel_lab3(&buffers->gray_lab2);
        t2 = now_ms();
        // keep the result for verification; freeing the Lab 2 frame is outside the timed region
        buffers->sobel_lab2 = *sobel_frame;
        delete sobel_frame;
    } else {
        t0 = now_ms();
        sobel_streaming(rgb_frame, &buffers->row_buffers, &buffers->sobel_stream);
        t2 = now_ms();
    }

    if(!times){return;}

    // the fused streaming pipeline has no separate grayscale / Sobel stage
    if(id != PIPE_STREAM){
        times->gray_ms.push_back(t1 - t0);
        times->sobel_ms.push_back(t2 - t1);
    }
    times->total_ms.push_back(t2 - t0);
}

/******************************
 * Function: benchmark_pipelines
 *
 * Description: This function times each requested pipeline on every frame, BENCH_REPEATS
 *  times. Each pipeline gets one untimed warmup frame. Pipelines are interleaved and the
 *  starting pipeline rotates every repeat so no version always runs first/last.
 *
 * param set: pointer to the frames at one resolution
 * param buffers: pointer to the preallocated buffers
 * param ids: list of pipeline ids to benchmark
 * param n_ids: number of pipeline ids
 * param times: array of timing lists, indexed by pipeline id
 *
 * return: none
 *
 ******************************/
static void benchmark_pipelines(FrameSet* set, PipelineBuffers* buffers, const int* ids,
                                int n_ids, PipelineTimes* times){
    // untimed warmup
    for(int i = 0; i < n_ids; i++){
        run_pipeline_timed(ids[i], &set->rgb[0], buffers, nullptr);
    }

    for(int rep = 0; rep < BENCH_REPEATS; rep++){
        for(int i = 0; i < n_ids; i++){
            int id = ids[(i + rep) % n_ids];
            for(size_t f = 0; f < set->rgb.size(); f++){
                run_pipeline_timed(id, &set->rgb[f], buffers, &times[id]);
            }
        }
    }
}

/******************************
 * Function: print_measurement_region
 *
 * Description: This function prints the measurement procedure shared by every image part.
 *
 * return: none
 *
 ******************************/
static void print_measurement_region(){
    std::cout << "Build: " << BUILD_FLAGS << ", single thread, no SIMD intrinsics\n";
    std::cout << "Timed region: grayscale + Sobel calls only (std::chrono::steady_clock). "
                 "Excluded: video decode, resize, buffer allocation, comparisons, PNG writes.\n";
    std::cout << "Samples: " << BENCH_FRAMES << " frames x " << BENCH_REPEATS
              << " repeats per implementation (+1 untimed warmup); median per-frame time reported.\n";
    std::cout << "Time per pixel = median frame time / (width * height).\n\n";
}

/*==========================================================================================
 * Part 1: baseline
 *========================================================================================*/

/******************************
 * Function: run_part1
 *
 * Description: This function benchmarks the baseline full-frame pipeline (cv::Mat::at),
 *  saves its gray and Sobel outputs for later correctness checks, and confirms the Lab 4
 *  baseline matches the Lab 3 baseline arithmetic.
 *
 * param sets: pointer to the frame sets
 *
 * return: int, 1 on success
 *
 ******************************/
static int run_part1(std::vector<FrameSet>* sets){
    std::cout << "==================================================================\n";
    std::cout << "Part 1: Baseline (full grayscale frame, cv::Mat::at access)\n";
    std::cout << "==================================================================\n";
    print_measurement_region();

    std::cout << "| Resolution | Pixels | Gray ms/frame | Sobel ms/frame | Total ms/frame | ns/pixel | FPS |\n";
    std::cout << "|------------|--------|---------------|----------------|----------------|----------|-----|\n";

    const int ids[] = {PIPE_AT};
    std::vector<std::string> saved;

    for(FrameSet& set : *sets){
        PipelineBuffers buffers;
        PipelineTimes times[3];
        double pixels = (double)set.width * set.height;

        allocate_buffers(&buffers, set.width, set.height);
        benchmark_pipelines(&set, &buffers, ids, 1, times);

        double total = median(times[PIPE_AT].total_ms);
        std::cout << std::fixed << std::setprecision(3)
                  << "| " << res_name(set.width, set.height)
                  << " | " << (long)pixels
                  << " | " << median(times[PIPE_AT].gray_ms)
                  << " | " << median(times[PIPE_AT].sobel_ms)
                  << " | " << total
                  << " | " << total * 1e6 / pixels
                  << " | " << std::setprecision(2) << 1000.0 / total << " |\n";

        // preserve baseline output of the comparison frame for later parts
        run_pipeline_timed(PIPE_AT, &set.rgb[CAPTURE_INDEX], &buffers, nullptr);
        std::string gray_path = capture_path("part1", "baseline_gray", set.width, set.height);
        std::string sobel_path = capture_path("part1", "baseline_sobel", set.width, set.height);
        cv::imwrite(gray_path, buffers.gray_at);
        cv::imwrite(sobel_path, buffers.sobel_at);
        saved.push_back(gray_path);
        saved.push_back(sobel_path);
    }

    std::cout << "\nSaved baseline images from frame " << CAPTURE_FRAME << ":\n";
    for(std::string& path : saved){std::cout << "  " << path << "\n";}

    // check that Lab 4's baseline reproduces Lab 3's baseline arithmetic
    FrameSet& check = (*sets)[2];
    PipelineBuffers buffers;
    allocate_buffers(&buffers, check.width, check.height);
    run_pipeline_timed(PIPE_AT, &check.rgb[CAPTURE_INDEX], &buffers, nullptr);

    cv::Mat lab3_gray3;
    grayscale_lab3(&check.rgb[CAPTURE_INDEX], &lab3_gray3);
    cv::Mat* lab3_sobel3 = sobel_lab3(&lab3_gray3);

    cv::Mat lab3_gray, lab3_sobel;
    cv::extractChannel(lab3_gray3, lab3_gray, 0);
    cv::extractChannel(*lab3_sobel3, lab3_sobel, 0);

    // Lab 3 left the gray value in the border; Lab 4 writes 0, so compare the interior only
    cv::Rect interior(1, 1, check.width - 2, check.height - 2);
    cv::Mat lab3_interior = lab3_sobel(interior);
    cv::Mat lab4_interior = buffers.sobel_at(interior);

    ImageDiff gray_diff = compare_images(&lab3_gray, &buffers.gray_at);
    ImageDiff sobel_diff = compare_images(&lab3_interior, &lab4_interior);

    std::cout << "\nLab 3 arithmetic check (" << res_name(check.width, check.height)
              << ", frame " << CAPTURE_FRAME << ", Lab 3 grayscale()/sobel() with Gy col_idx fix, channel 0):\n";
    std::cout << "| Output | Differing pixels | Max abs diff | Bit-identical |\n";
    std::cout << "|--------|------------------|--------------|---------------|\n";
    std::cout << "| Grayscale (full frame) " << diff_string(&gray_diff) << "\n";
    std::cout << "| Sobel (interior, border excluded) " << diff_string(&sobel_diff) << "\n";

    delete lab3_sobel3;
    return 1;
}

/*==========================================================================================
 * Part 3: pixel access
 *========================================================================================*/

/******************************
 * Function: run_part3
 *
 * Description: This function compares .at() and row-pointer access. Both pipelines keep the
 *  full gray frame, traverse row-major, and use identical arithmetic and border policy.
 *
 * param sets: pointer to the frame sets
 *
 * return: int, 1 if every output was identical
 *
 ******************************/
static int run_part3(std::vector<FrameSet>* sets){
    std::cout << "==================================================================\n";
    std::cout << "Part 3: Pixel-Access Experiment (cv::Mat::at vs. row pointers)\n";
    std::cout << "==================================================================\n";
    print_measurement_region();

    const int ids[] = {PIPE_AT, PIPE_PTR};
    bool all_identical = true;

    std::vector<std::string> sobel_rows, stage_rows, verify_rows, saved;

    for(FrameSet& set : *sets){
        PipelineBuffers buffers;
        PipelineTimes times[3];
        double pixels = (double)set.width * set.height;
        std::string res = res_name(set.width, set.height);

        allocate_buffers(&buffers, set.width, set.height);
        benchmark_pipelines(&set, &buffers, ids, 2, times);

        double at_sobel = median(times[PIPE_AT].sobel_ms);
        double ptr_sobel = median(times[PIPE_PTR].sobel_ms);
        double at_gray = median(times[PIPE_AT].gray_ms);
        double ptr_gray = median(times[PIPE_PTR].gray_ms);
        double at_total = median(times[PIPE_AT].total_ms);
        double ptr_total = median(times[PIPE_PTR].total_ms);

        std::ostringstream line;
        line << std::fixed << std::setprecision(3);
        line << "| " << res << " | cv::Mat::at() | " << at_sobel << " | " << at_sobel * 1e6 / pixels
             << " | 1.00x |\n";
        line << "| " << res << " | Row pointers  | " << ptr_sobel << " | " << ptr_sobel * 1e6 / pixels
             << " | " << std::setprecision(2) << at_sobel / ptr_sobel << "x |";
        sobel_rows.push_back(line.str());

        std::ostringstream stage;
        stage << std::fixed << std::setprecision(3);
        stage << "| " << res << " | " << at_gray << " | " << ptr_gray << " | "
              << std::setprecision(2) << at_gray / ptr_gray << "x | " << std::setprecision(3)
              << at_total << " | " << ptr_total << " | " << std::setprecision(2)
              << at_total / ptr_total << "x |";
        stage_rows.push_back(stage.str());

        // verification pass over every frame (outside the timed region)
        ImageDiff gray_total = {true, 0, 0, true};
        ImageDiff sobel_total = {true, 0, 0, true};
        for(size_t f = 0; f < set.rgb.size(); f++){
            run_pipeline_timed(PIPE_AT, &set.rgb[f], &buffers, nullptr);
            run_pipeline_timed(PIPE_PTR, &set.rgb[f], &buffers, nullptr);
            ImageDiff gray_diff = compare_images(&buffers.gray_at, &buffers.gray_ptr);
            ImageDiff sobel_diff = compare_images(&buffers.sobel_at, &buffers.sobel_ptr);
            accumulate_diff(&gray_total, &gray_diff);
            accumulate_diff(&sobel_total, &sobel_diff);
        }

        // compare the capture frame against the saved Part 1 baseline capture
        run_pipeline_timed(PIPE_AT, &set.rgb[CAPTURE_INDEX], &buffers, nullptr);
        run_pipeline_timed(PIPE_PTR, &set.rgb[CAPTURE_INDEX], &buffers, nullptr);
        std::string baseline_path = capture_path("part1", "baseline_sobel", set.width, set.height);
        cv::Mat baseline = cv::imread(baseline_path, cv::IMREAD_UNCHANGED);
        ImageDiff saved_diff = compare_images(&baseline, &buffers.sobel_ptr);

        verify_rows.push_back("| " + res + " | Grayscale, " + std::to_string(set.rgb.size()) +
                              " frames " + diff_string(&gray_total));
        verify_rows.push_back("| " + res + " | Sobel, " + std::to_string(set.rgb.size()) +
                              " frames " + diff_string(&sobel_total));
        verify_rows.push_back("| " + res + " | Sobel ptr vs " + baseline_path + " " +
                              (baseline.empty() ? std::string("| capture missing (run part1) | | |")
                                                : diff_string(&saved_diff)));

        if(!gray_total.identical || !sobel_total.identical){all_identical = false;}

        std::string at_path = capture_path("part3", "sobel_at", set.width, set.height);
        std::string ptr_path = capture_path("part3", "sobel_ptr", set.width, set.height);
        cv::imwrite(at_path, buffers.sobel_at);
        cv::imwrite(ptr_path, buffers.sobel_ptr);
        saved.push_back(at_path);
        saved.push_back(ptr_path);
    }

    std::cout << "Sobel stage only (same gray input, same traversal order):\n";
    std::cout << "| Resolution | Pixel-access method | Execution time (ms/frame) | Time per pixel (ns) | Relative performance |\n";
    std::cout << "|------------|---------------------|---------------------------|---------------------|----------------------|\n";
    for(std::string& row : sobel_rows){std::cout << row << "\n";}

    std::cout << "\nGrayscale stage and full pipeline (ms/frame):\n";
    std::cout << "| Resolution | Gray .at | Gray ptr | Gray speedup | Total .at | Total ptr | Total speedup |\n";
    std::cout << "|------------|----------|----------|--------------|-----------|-----------|---------------|\n";
    for(std::string& row : stage_rows){std::cout << row << "\n";}

    std::cout << "\nCorrectness (.at output vs. row-pointer output):\n";
    std::cout << "| Resolution | Comparison | Differing pixels | Max abs diff | Bit-identical |\n";
    std::cout << "|------------|------------|------------------|--------------|---------------|\n";
    for(std::string& row : verify_rows){std::cout << row << "\n";}

    std::cout << "\nSaved comparison images from frame " << CAPTURE_FRAME << ":\n";
    for(std::string& path : saved){std::cout << "  " << path << "\n";}

    std::cout << "\nAll outputs bit-identical: " << (all_identical ? "yes" : "NO") << "\n";
    return all_identical ? 1 : 0;
}

/*==========================================================================================
 * Part 4: data-movement analysis
 *========================================================================================*/

/******************************
 * Function: run_part4
 *
 * Description: This function prints the per-frame buffer sizes and the minimum bytes read
 *  from / written to Mat objects by the baseline pipeline at every resolution, next to the
 *  streaming pipeline's intermediate storage. No timing.
 *
 * return: int, 1
 *
 ******************************/
static int run_part4(){
    CacheInfo cache = read_cache_info();

    std::cout << "==================================================================\n";
    std::cout << "Part 4: Data Movement of the Baseline Pipeline (per frame)\n";
    std::cout << "==================================================================\n";
    print_cache_info(&cache);
    std::cout << "Assumptions: BGR input CV_8UC3 (3 B/px), gray and Sobel CV_8UC1 (1 B/px); every Mat\n"
                 "byte is read or written at least once (perfect reuse of Sobel neighbors); kernel\n"
                 "tables, locals, and row buffers of 3 rows stay in registers/L1 and are not counted as\n"
                 "Mat traffic; write-allocate (read-for-ownership) traffic is not counted.\n\n";

    std::cout << "| Resolution | BGR input (read) | Gray frame (write + read) | Gray fits in | Sobel output (write) "
                 "| Min bytes read | Min bytes written | Min total | Gray loads issued by Sobel (9/px) |\n";
    std::cout << "|------------|------------------|---------------------------|--------------|----------------------"
                 "|----------------|-------------------|-----------|-----------------------------------|\n";

    for(const Resolution& res : RESOLUTIONS){
        double pixels = (double)res.width * res.height;
        double interior = (double)(res.width - 2) * (res.height - 2);
        double bgr = 3.0 * pixels;
        double gray = pixels;
        double sobel = pixels;
        double reads = bgr + gray;
        double writes = gray + sobel;

        std::cout << "| " << res_name(res.width, res.height)
                  << " | " << format_bytes(bgr)
                  << " | " << format_bytes(gray) << " + " << format_bytes(gray)
                  << " | " << fits_in(&cache, gray)
                  << " | " << format_bytes(sobel)
                  << " | " << format_bytes(reads) << " (4WH)"
                  << " | " << format_bytes(writes) << " (2WH)"
                  << " | " << format_bytes(reads + writes) << " (6WH)"
                  << " | " << (long)(9 * interior) << " loads = " << format_bytes(9 * interior) << " |\n";
    }

    std::cout << "\nIntermediate storage, baseline vs. streaming:\n";
    std::cout << "| Resolution | Baseline gray frame (W*H) | Fits in | Streaming 3 rows (3*W) | Fits in "
                 "| Streaming Mat bytes that can leave the core (3WH + WH) | vs. baseline 6WH |\n";
    std::cout << "|------------|---------------------------|---------|------------------------|---------"
                 "|--------------------------------------------------------|------------------|\n";

    for(const Resolution& res : RESOLUTIONS){
        double pixels = (double)res.width * res.height;
        double rows3 = 3.0 * res.width;

        std::cout << "| " << res_name(res.width, res.height)
                  << " | " << format_bytes(pixels)
                  << " | " << fits_in(&cache, pixels)
                  << " | " << format_bytes(rows3)
                  << " | " << fits_in(&cache, rows3)
                  << " | " << format_bytes(4.0 * pixels)
                  << " | " << std::fixed << std::setprecision(2) << 4.0 / 6.0 << "x |\n";
    }

    std::cout << "\nReuse: each gray pixel is read by up to 9 Sobel neighborhoods (3 per output row, for\n"
                 "3 consecutive output rows). Horizontal reuse happens within ~2 pixels (same cache line);\n"
                 "vertical reuse happens one and two output rows later, i.e. 1*W and 2*W bytes later.\n";
    return 1;
}

/*==========================================================================================
 * Part 5 / 6: streaming
 *========================================================================================*/

/******************************
 * Function: run_stride_test
 *
 * Description: This function runs the .at baseline and the streaming pipeline on a
 *  non-continuous ROI (row step larger than width*channels) writing into a padded output
 *  ROI, to prove every version indexes rows through the Mat step, not width.
 *
 * param set: pointer to the frames at one resolution
 *
 * return: bool, true if the outputs are identical
 *
 ******************************/
static bool run_stride_test(FrameSet* set){
    // odd-sized ROI inside the full frame: rows are padded by the parent's step
    cv::Rect roi(5, 3, set->width - 11, set->height - 7);
    cv::Mat rgb_roi = set->rgb[CAPTURE_INDEX](roi);

    // outputs also live inside larger padded parents
    cv::Mat gray_parent(roi.height + 4, roi.width + 13, CV_8UC1, cv::Scalar(77));
    cv::Mat at_parent(roi.height + 4, roi.width + 13, CV_8UC1, cv::Scalar(77));
    cv::Mat stream_parent(roi.height + 4, roi.width + 13, CV_8UC1, cv::Scalar(77));
    cv::Rect out_roi(7, 2, roi.width, roi.height);
    cv::Mat gray_out = gray_parent(out_roi);
    cv::Mat at_out = at_parent(out_roi);
    cv::Mat stream_out = stream_parent(out_roi);
    cv::Mat row_buffers(3, roi.width, CV_8UC1);

    grayscale_at(&rgb_roi, &gray_out);
    sobel_at(&gray_out, &at_out);
    sobel_streaming(&rgb_roi, &row_buffers, &stream_out);

    ImageDiff roi_diff = compare_images(&at_out, &stream_out);

    // the padding around the output ROI must be untouched
    ImageDiff parent_diff = compare_images(&at_parent, &stream_parent);

    std::cout << "\nStride / padding test (" << res_name(set->width, set->height) << " frame, ROI "
              << res_name(roi.width, roi.height) << ", input step " << rgb_roi.step[0]
              << " B vs " << roi.width * 3 << " B packed, output step " << stream_out.step[0]
              << " B vs " << roi.width << " B packed, input continuous: "
              << (rgb_roi.isContinuous() ? "yes" : "no") << "):\n";
    std::cout << "| Comparison | Differing pixels | Max abs diff | Bit-identical |\n";
    std::cout << "|------------|------------------|--------------|---------------|\n";
    std::cout << "| Streaming vs .at baseline (ROI) " << diff_string(&roi_diff) << "\n";
    std::cout << "| Padded parents incl. untouched padding " << diff_string(&parent_diff) << "\n";

    return roi_diff.identical && parent_diff.identical;
}

/******************************
 * Function: run_part5
 *
 * Description: This function benchmarks the baseline (.at), the full-frame row-pointer
 *  pipeline, and the three-row streaming pipeline at every resolution, verifies the streaming
 *  output against the baseline, and saves the streaming output.
 *
 *  Two speedups are reported: vs. the .at baseline (Part 1), and vs. the full-frame
 *  row-pointer pipeline, which uses the exact same row functions as streaming, so that
 *  column isolates the effect of keeping only three gray rows.
 *
 * param sets: pointer to the frame sets
 *
 * return: int, 1 if every output was identical
 *
 ******************************/
static int run_part5(std::vector<FrameSet>* sets){
    CacheInfo cache = read_cache_info();

    std::cout << "==================================================================\n";
    std::cout << "Part 5 / 6: Three-Row Streaming Pipeline\n";
    std::cout << "==================================================================\n";
    print_cache_info(&cache);
    print_measurement_region();

    const int ids[] = {PIPE_AT, PIPE_PTR, PIPE_STREAM};
    bool all_identical = true;

    std::vector<std::string> result_rows, verify_rows, saved;

    for(FrameSet& set : *sets){
        PipelineBuffers buffers;
        PipelineTimes times[3];
        double pixels = (double)set.width * set.height;
        std::string res = res_name(set.width, set.height);

        allocate_buffers(&buffers, set.width, set.height);
        benchmark_pipelines(&set, &buffers, ids, 3, times);

        double at_ms = median(times[PIPE_AT].total_ms);
        double ptr_ms = median(times[PIPE_PTR].total_ms);
        double storage[3] = {pixels, pixels, 3.0 * set.width};
        const char* storage_name[3] = {"Complete gray frame", "Complete gray frame", "Three gray rows"};

        for(int id = 0; id < 3; id++){
            double ms = median(times[id].total_ms);
            std::ostringstream line;
            line << std::fixed << std::setprecision(3)
                 << "| " << res << " | " << PIPELINE_NAMES[id]
                 << " | " << storage_name[id] << " (" << format_bytes(storage[id]) << ")"
                 << " | " << fits_in(&cache, storage[id])
                 << " | " << ms
                 << " | " << ms * 1e6 / pixels
                 << " | " << std::setprecision(2) << at_ms / ms << "x"
                 << " | " << ptr_ms / ms << "x |";
            result_rows.push_back(line.str());
        }

        // verification pass over every frame (outside the timed region)
        ImageDiff at_total = {true, 0, 0, true};
        ImageDiff ptr_total = {true, 0, 0, true};
        for(size_t f = 0; f < set.rgb.size(); f++){
            run_pipeline_timed(PIPE_AT, &set.rgb[f], &buffers, nullptr);
            run_pipeline_timed(PIPE_PTR, &set.rgb[f], &buffers, nullptr);
            run_pipeline_timed(PIPE_STREAM, &set.rgb[f], &buffers, nullptr);
            ImageDiff at_diff = compare_images(&buffers.sobel_at, &buffers.sobel_stream);
            ImageDiff ptr_diff = compare_images(&buffers.sobel_ptr, &buffers.sobel_stream);
            accumulate_diff(&at_total, &at_diff);
            accumulate_diff(&ptr_total, &ptr_diff);
        }

        // compare the capture frame against the saved Part 1 baseline capture
        run_pipeline_timed(PIPE_STREAM, &set.rgb[CAPTURE_INDEX], &buffers, nullptr);
        std::string baseline_path = capture_path("part1", "baseline_sobel", set.width, set.height);
        cv::Mat baseline = cv::imread(baseline_path, cv::IMREAD_UNCHANGED);
        ImageDiff saved_diff = compare_images(&baseline, &buffers.sobel_stream);

        verify_rows.push_back("| " + res + " | Streaming vs .at baseline, " +
                              std::to_string(set.rgb.size()) + " frames " + diff_string(&at_total));
        verify_rows.push_back("| " + res + " | Streaming vs full-frame ptr, " +
                              std::to_string(set.rgb.size()) + " frames " + diff_string(&ptr_total));
        verify_rows.push_back("| " + res + " | Streaming vs " + baseline_path + " " +
                              (baseline.empty() ? std::string("| capture missing (run part1) | | |")
                                                : diff_string(&saved_diff)));

        if(!at_total.identical || !ptr_total.identical){all_identical = false;}

        std::string stream_path = capture_path("part5", "streaming_sobel", set.width, set.height);
        cv::imwrite(stream_path, buffers.sobel_stream);
        saved.push_back(stream_path);
    }

    std::cout << "| Resolution | Implementation | Intermediate storage | Fits in | Execution time (ms/frame) "
                 "| Time per pixel (ns) | Speedup vs .at baseline | Speedup vs full-frame ptr |\n";
    std::cout << "|------------|----------------|----------------------|---------|---------------------------"
                 "|---------------------|-------------------------|---------------------------|\n";
    for(std::string& row : result_rows){std::cout << row << "\n";}

    std::cout << "\nCorrectness:\n";
    std::cout << "| Resolution | Comparison | Differing pixels | Max abs diff | Bit-identical |\n";
    std::cout << "|------------|------------|------------------|--------------|---------------|\n";
    for(std::string& row : verify_rows){std::cout << row << "\n";}

    if(!run_stride_test(&sets->back())){all_identical = false;}

    std::cout << "\nSaved streaming images from frame " << CAPTURE_FRAME << ":\n";
    for(std::string& path : saved){std::cout << "  " << path << "\n";}

    std::cout << "\nAll outputs bit-identical: " << (all_identical ? "yes" : "NO") << "\n";
    return all_identical ? 1 : 0;
}

/*==========================================================================================
 * Lab 5: compiler optimization
 *========================================================================================*/

/******************************
 * Function: run_lab5
 *
 * Description: This function benchmarks one implementation over the Lab 5 window and prints
 *  its grayscale, Sobel, and total time at every resolution. The same source is built once
 *  per set of compiler flags (see the Makefile), so the build flags are the only thing that
 *  changes between runs of the current implementation.
 *
 *  Measurement: the video is played once from its first frame, and every frame up to the
 *  LAB5_END_SECONDS time mark is processed once. Each frame is decoded, scaled into the
 *  preallocated buffer of every resolution (untimed), and run through the pipeline at each
 *  resolution (timed); then the next frame is read. Only one frame is held in memory. One
 *  untimed warmup on the first frame per resolution; the median per-frame time is reported.
 *  (Lab 4 preloaded all frames instead; see the LAB5_END_SECONDS note in video_driver.hpp.)
 *
 *  Correctness: the -O0 build of the current implementation saves the reference captures
 *  (captures/lab5_O0_current_*.png) of the last frame of the window. Every other run compares
 *  its last frame against them, so a compiler flag that changed the output would show up
 *  here. The Lab 2 baseline writes three-channel frames and leaves gray values in the Sobel
 *  border, so it is compared on channel 0, with the Sobel border excluded. Differences are
 *  reported, not treated as a failure: the source is the same in every build, so a
 *  difference is a measured effect of the compiler (e.g. -O3 contracting the double
 *  grayscale math into fused multiply-adds).
 *
 * param video_file: path to the input video
 * param impl: "current" (Lab 4 row-pointer pipeline) or "lab2" (Lab 2 baseline)
 *
 * return: int, 1 if the run completed and every comparison could be made, 0 otherwise
 *
 ******************************/
static int run_lab5(const char* video_file, const std::string& impl){
    bool lab2 = (impl == "lab2");
    int id = lab2 ? PIPE_LAB2 : PIPE_PTR;
    std::string tag = std::string(BUILD_TAG) + "_" + impl;
    bool is_reference = (!lab2 && std::string(BUILD_TAG) == "O0");
    int n_res = sizeof(RESOLUTIONS) / sizeof(RESOLUTIONS[0]);

    cv::VideoCapture cap(video_file);
    if(!cap.isOpened()){
        std::cout << "Error: couldn't open file: " << video_file << std::endl;
        return 0;
    }
    double fps = cap.get(cv::CAP_PROP_FPS);
    int n_frames = (int)(LAB5_END_SECONDS * fps + 0.5);
    int last_frame = n_frames - 1;

    std::cout << "==================================================================\n";
    std::cout << "Lab 5: Compiler Optimization (" << BUILD_FLAGS << ", "
              << (lab2 ? "Lab 2 baseline" : "current implementation") << ")\n";
    std::cout << "==================================================================\n";
    std::cout << std::fixed << std::setprecision(2)
              << "Input: " << video_file << ", played once from the start to the "
              << LAB5_END_SECONDS << " s mark: frames 0-" << last_frame << " (" << n_frames
              << " frames at " << fps << " fps), scaled with cv::resize(INTER_AREA) outside the timed region\n";
    std::cout << "Build: " << BUILD_FLAGS << ", single thread, no SIMD intrinsics\n";
    std::cout << "Timed region: grayscale + Sobel calls only (std::chrono::steady_clock). "
                 "Excluded: video decode, resize, buffer allocation, comparisons, PNG writes.\n";
    std::cout << "Samples: " << n_frames << " frames x 1 pass per resolution (+1 untimed warmup); "
              << "one frame decoded at a time, outside the timed region; median per-frame time reported.\n";
    std::cout << "Time per pixel = median frame time / (width * height).\n\n";
    if(lab2){
        std::cout << "Implementation: Lab 2 baseline grayscale()/sobel() (grayscale_lab3 / sobel_lab3, "
                     "Gy col_idx fix): cv::Mat::at<cv::Vec3b>, 3-channel gray copy, new Sobel frame per call\n\n";
    } else {
        std::cout << "Implementation: Lab 4 full-frame row-pointer pipeline (grayscale_ptr / sobel_ptr): "
                     "single-channel gray frame, row pointers, row-major\n\n";
    }

    // every buffer, including each resolution's scaled-frame buffer, is allocated once here
    std::vector<PipelineBuffers> buffers(n_res);
    std::vector<PipelineTimes> times(n_res);
    std::vector<cv::Mat> scaled(n_res);
    for(int r = 0; r < n_res; r++){
        allocate_buffers(&buffers[r], RESOLUTIONS[r].width, RESOLUTIONS[r].height);
        scaled[r].create(RESOLUTIONS[r].height, RESOLUTIONS[r].width, CV_8UC3);
    }

    // play the video once: decode a frame, scale it (untimed), time it at every resolution
    cv::Mat frame;
    double decode_ms = 0, bench_start = now_ms();
    for(int f = 0; f < n_frames; f++){
        double d0 = now_ms();
        if(!cap.read(frame)){
            std::cout << "Error: video ended before frame " << last_frame << std::endl;
            return 0;
        }
        for(int r = 0; r < n_res; r++){
            // native resolution is copied so the next read() can't change it mid-run
            if(frame.cols == RESOLUTIONS[r].width && frame.rows == RESOLUTIONS[r].height){frame.copyTo(scaled[r]);}
            else{cv::resize(frame, scaled[r], scaled[r].size(), 0, 0, cv::INTER_AREA);}
        }
        decode_ms += now_ms() - d0;

        for(int r = 0; r < n_res; r++){
            if(f == 0){run_pipeline_timed(id, &scaled[r], &buffers[r], nullptr);}   // warmup
            run_pipeline_timed(id, &scaled[r], &buffers[r], &times[r]);
        }

        // progress goes to stderr so it shows while running but is not saved to the outputs
        if((f + 1) % 60 == 0 || f + 1 == n_frames){
            std::cerr << "  " << tag << ": " << f + 1 << "/" << n_frames << " frames, "
                      << std::fixed << std::setprecision(0) << (now_ms() - bench_start) / 1000.0 << " s\n";
        }
    }
    cap.release();

    std::cout << "| Resolution | Pixels | Gray ms/frame | Sobel ms/frame | Total ms/frame | ns/pixel | FPS |\n";
    std::cout << "|------------|--------|---------------|----------------|----------------|----------|-----|\n";

    bool all_identical = true;
    bool all_compared = true;
    std::vector<std::string> verify_rows, saved;

    for(int r = 0; r < n_res; r++){
        int width = RESOLUTIONS[r].width, height = RESOLUTIONS[r].height;
        double pixels = (double)width * height;
        std::string res = res_name(width, height);

        double total = median(times[r].total_ms);
        std::cout << std::fixed << std::setprecision(3)
                  << "| " << res
                  << " | " << (long)pixels
                  << " | " << median(times[r].gray_ms)
                  << " | " << median(times[r].sobel_ms)
                  << " | " << total
                  << " | " << total * 1e6 / pixels
                  << " | " << std::setprecision(2) << 1000.0 / total << " |\n";

        // outputs of the last frame of the window (outside the timed region)
        run_pipeline_timed(id, &scaled[r], &buffers[r], nullptr);
        cv::Mat gray, sobel;
        if(lab2){
            cv::extractChannel(buffers[r].gray_lab2, gray, 0);
            cv::extractChannel(buffers[r].sobel_lab2, sobel, 0);
        } else {
            gray = buffers[r].gray_ptr;
            sobel = buffers[r].sobel_ptr;
        }

        std::string gray_path = capture_path("lab5", (tag + "_gray").c_str(), width, height);
        std::string sobel_path = capture_path("lab5", (tag + "_sobel").c_str(), width, height);
        cv::imwrite(gray_path, gray);
        cv::imwrite(sobel_path, sobel);
        saved.push_back(gray_path);
        saved.push_back(sobel_path);

        if(is_reference){
            verify_rows.push_back("| " + res + " | Gray + Sobel saved as the -O0 reference | - | - | - |");
            continue;
        }

        // compare against the -O0 reference captures
        std::string ref_gray_path = capture_path("lab5", "O0_current_gray", width, height);
        std::string ref_sobel_path = capture_path("lab5", "O0_current_sobel", width, height);
        cv::Mat ref_gray = cv::imread(ref_gray_path, cv::IMREAD_UNCHANGED);
        cv::Mat ref_sobel = cv::imread(ref_sobel_path, cv::IMREAD_UNCHANGED);
        if(ref_gray.empty() || ref_sobel.empty()){
            verify_rows.push_back("| " + res + " | -O0 reference | capture missing (run the -O0 build first) | | |");
            all_compared = false;
            continue;
        }

        cv::Mat sobel_cmp = sobel, ref_sobel_cmp = ref_sobel;
        if(lab2){
            cv::Rect interior(1, 1, width - 2, height - 2);
            sobel_cmp = sobel(interior);
            ref_sobel_cmp = ref_sobel(interior);
        }

        ImageDiff gray_diff = compare_images(&ref_gray, &gray);
        ImageDiff sobel_diff = compare_images(&ref_sobel_cmp, &sobel_cmp);
        verify_rows.push_back("| " + res + " | Grayscale vs " + ref_gray_path + " " + diff_string(&gray_diff));
        verify_rows.push_back("| " + res + " | Sobel" + (lab2 ? " (interior)" : "") + " vs " +
                              ref_sobel_path + " " + diff_string(&sobel_diff));

        if(!gray_diff.identical || !sobel_diff.identical){all_identical = false;}
    }

    std::cout << "\nCorrectness (frame " << last_frame << ", vs. the -O0 build of the current implementation"
              << (lab2 ? ", channel 0" : "") << "):\n";
    std::cout << "| Resolution | Comparison | Differing pixels | Max abs diff | Bit-identical |\n";
    std::cout << "|------------|------------|------------------|--------------|---------------|\n";
    for(std::string& row : verify_rows){std::cout << row << "\n";}

    std::cout << "\nSaved images from frame " << last_frame << ":\n";
    for(std::string& path : saved){std::cout << "  " << path << "\n";}

    std::cout << "\nAll outputs bit-identical: " << (is_reference ? "n/a (this run is the reference)"
                                                 : (!all_compared ? "NO (reference missing)"
                                                 : (all_identical ? "yes" : "NO"))) << "\n";
    if(all_compared && !all_identical){
        std::cout << "Note: every build compiles the same source, so these differences come from the "
                     "compiler's code generation, not from the implementation.\n";
    }

    std::cout << std::fixed << std::setprecision(1)
              << "Decoding + scaling (untimed): " << decode_ms / 1000.0 << " s\n";
    return all_compared ? 1 : 0;
}

/******************************
 * Function: main
 *
 * Description: selects the experiment, loads frames when needed (Lab 5 streams its own),
 *  runs the experiment
 *
 * return: int, 0 on success, 1 on failure

******************************/
int main(int argc, char *argv[]){
    if(argc < 2 || argc > 4){
        std::cout << "Usage: " << argv[0] << " <part1|part2|part3|part4|part5> [video]\n"
                  << "       " << argv[0] << " lab5 <video> <current|lab2>" << std::endl;
        return 1;
    }

    std::string part = argv[1];

    if(part == "part2"){return run_traversal_experiment() ? 0 : 1;}
    if(part == "part4"){return run_part4() ? 0 : 1;}

    if(part != "part1" && part != "part3" && part != "part5" && part != "lab5"){
        std::cout << "Unknown part: " << part << std::endl;
        return 1;
    }
    if(part == "lab5"){
        if(argc != 4 || (std::string(argv[3]) != "current" && std::string(argv[3]) != "lab2")){
            std::cout << "Usage: " << argv[0] << " lab5 <video> <current|lab2>" << std::endl;
            return 1;
        }
    } else if(argc != 3){
        std::cout << "Usage: " << argv[0] << " " << part << " <video>" << std::endl;
        return 1;
    }

    std::filesystem::create_directories(CAPTURE_DIR);

    // Lab 5 streams the video itself instead of preloading BENCH_FRAMES frames
    if(part == "lab5"){
        double lab5_start = now_ms();
        int lab5_ok = run_lab5(argv[2], argv[3]);
        std::cout << std::fixed << std::setprecision(1)
                  << "\nRun time: " << (now_ms() - lab5_start) / 1000.0 << " s total\n";
        return lab5_ok ? 0 : 1;
    }

    // wall-clock time of the whole run (decode + scaling + benchmarks + verification + PNGs)
    double run_start = now_ms();

    std::vector<FrameSet> sets;
    if(!load_frames(argv[2], &sets)){return 1;}
    double load_end = now_ms();

    int ok = 0;
    if(part == "part1"){ok = run_part1(&sets);}
    if(part == "part3"){ok = run_part3(&sets);}
    if(part == "part5"){ok = run_part5(&sets);}

    double run_end = now_ms();
    std::cout << std::fixed << std::setprecision(1)
              << "\nRun time: " << (run_end - run_start) / 1000.0 << " s total ("
              << (load_end - run_start) / 1000.0 << " s decoding + scaling " << BENCH_FRAMES
              << " frames, " << (run_end - load_end) / 1000.0
              << " s benchmarking, verifying, and saving captures)\n";

    return ok ? 0 : 1;
}
