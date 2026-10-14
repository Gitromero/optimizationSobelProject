/************************
 * File: video_driver.hpp
 *
 * Description: Shared Sobel kernels and experiment settings for Lab 4 and Lab 5. The kernels
 *          are unchanged from Lab 3 so every implementation uses the same arithmetic.
 *          Lab 5 builds the same source with different compiler flags; BUILD_FLAGS and
 *          BUILD_TAG (set by the Makefile with -D) label which build produced each output, and
 *          the LAB5_* settings define its longer, streamed measurement window.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef VIDEO_DRIVER_HPP
#define VIDEO_DRIVER_HPP

#include <stdint.h>

inline int8_t Gx[3][3] = {
    {-1, 0, 1},
    {-2, 0, 2},
    {-1, 0, 1}
};

inline int8_t Gy[3][3] = {
    {1, 2, 1},
    {0, 0, 0},
    {-1, -2, -1}
};

// first video frame of the test window (same start Lab 3 used, past the black intro;
// frames 60-179 are the Big Buck Bunny title card)
const int START_FRAME = 60;

// number of consecutive frames (starting at START_FRAME) processed per measurement
// 120 frames = 2 seconds of the 60 fps source video
// (override with -DBENCH_FRAMES_N=<n>, e.g. the Makefile's quick target uses 1)
#ifndef BENCH_FRAMES_N
#define BENCH_FRAMES_N 120
#endif
const int BENCH_FRAMES = BENCH_FRAMES_N;

// index (within the test window) of the frame saved to captures/: the last test frame
const int CAPTURE_INDEX = BENCH_FRAMES - 1;
const int CAPTURE_FRAME = START_FRAME + CAPTURE_INDEX;

// number of times each implementation re-processes the BENCH_FRAMES frames
// (override with -DBENCH_REPEATS_N=<n>)
#ifndef BENCH_REPEATS_N
#define BENCH_REPEATS_N 3
#endif
const int BENCH_REPEATS = BENCH_REPEATS_N;

/*------------------------------------------------------------------------------------------
 * Lab 5 measurement window. Every Lab 5 run plays the video once from the first frame and
 * processes every frame up to the same time mark, LAB5_END_SECONDS (18 s = 1080 frames of the
 * 60 fps video, sized so all five runs take ~40 min on the Pi 5).
 *
 * Change from Lab 4: Lab 4 preloaded BENCH_FRAMES frames at every resolution before timing.
 * That cannot scale to 1080 frames (~38 GB at all five resolutions), so Lab 5 decodes one
 * frame at a time instead. The Lab 4 measurement rules still hold: decode and resize happen
 * outside the timed region, every buffer (including the scaled-frame buffers) is allocated
 * before the loop and reused, and every build processes the same frames.
 * (override with -DLAB5_END_SECONDS_N=<s>, e.g. for a short test build)
 *----------------------------------------------------------------------------------------*/
#ifndef LAB5_END_SECONDS_N
#define LAB5_END_SECONDS_N 18
#endif
const int LAB5_END_SECONDS = LAB5_END_SECONDS_N;

// directory where image captures are written (relative to the project root); the Lab 5
// builds set it with -DCAPTURE_DIR_PATH so each set of results keeps its own captures
#ifndef CAPTURE_DIR_PATH
#define CAPTURE_DIR_PATH "captures"
#endif
const char* const CAPTURE_DIR = CAPTURE_DIR_PATH;

// compiler flags of this build, printed with every measurement (Lab 5)
#ifndef BUILD_FLAGS
#define BUILD_FLAGS "-O0"
#endif

// short build name used in capture file names, e.g. captures/lab5_O3_current_sobel_1920x1080.png
#ifndef BUILD_TAG
#define BUILD_TAG "O0"
#endif

#endif
