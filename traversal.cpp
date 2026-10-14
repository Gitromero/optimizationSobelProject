/************************
 * File: traversal.cpp
 *
 * Description: This file includes the Part 2 memory traversal experiment. A 2-D int32 array
 *          is stored row-major in one contiguous block (element[r][c] lives at r*cols + c),
 *          then summed in row-major order (stride 4 B) and column-major order
 *          (stride cols*4 B). Both traversals do the identical operation on every element and
 *          return a checksum so the work is observable.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <algorithm>
#include <chrono>
#include <iomanip>
#include <iostream>
#include <stdint.h>
#include <vector>

#include "cache_info.hpp"
#include "traversal.hpp"

// array shapes tested, from fits-in-L1 to far larger than L3
struct TraversalSize {
    const char* size_class;
    int rows;
    int cols;
};

static const TraversalSize TRAVERSAL_SIZES[] = {
    {"small",  64,     64},
    {"small",  256,    256},
    {"medium", 1024,   1024},
    {"medium", 4096,   4096},
    {"large",  100000, 1024},
};

// each timed trial visits at least this many elements (small arrays are swept repeatedly)
static const long TARGET_VISITS = 1L << 26;

// number of timed trials per traversal order; the median is reported
static const int TRAVERSAL_TRIALS = 5;

/******************************
 * Function: traverse_row_major
 *
 * Description: This function visits every element one row at a time. Consecutive accesses
 *  are 4 bytes apart, so 16 accesses share each 64-byte cache line.
 *
 * param array: pointer to the first element of the row-major array
 * param rows: number of rows
 * param cols: number of columns
 *
 * return: uint64_t, checksum (sum of every element)
 *
 ******************************/
uint64_t traverse_row_major(const int32_t* array, int rows, int cols){
    uint64_t checksum = 0;

    for(int r = 0; r < rows; r++){
        for(int c = 0; c < cols; c++){
            checksum += array[(long)r * cols + c];
        }
    }

    return checksum;
}

/******************************
 * Function: traverse_col_major
 *
 * Description: This function visits every element one column at a time. Consecutive
 *  accesses are cols*4 bytes apart, so each access lands on a different cache line.
 *
 * param array: pointer to the first element of the row-major array
 * param rows: number of rows
 * param cols: number of columns
 *
 * return: uint64_t, checksum (sum of every element)
 *
 ******************************/
uint64_t traverse_col_major(const int32_t* array, int rows, int cols){
    uint64_t checksum = 0;

    for(int c = 0; c < cols; c++){
        for(int r = 0; r < rows; r++){
            checksum += array[(long)r * cols + c];
        }
    }

    return checksum;
}

/******************************
 * Function: time_traversal
 *
 * Description: This function times `passes` sweeps of one traversal order and returns the
 *  elapsed milliseconds. The checksum of the final sweep is returned through checksum_out.
 *
 * param traverse: traversal function to time
 * param array: pointer to the array
 * param rows: number of rows
 * param cols: number of columns
 * param passes: number of full sweeps in this trial
 * param checksum_out: pointer that receives one sweep's checksum
 *
 * return: double, elapsed milliseconds for all passes
 *
 ******************************/
static double time_traversal(uint64_t (*traverse)(const int32_t*, int, int), const int32_t* array,
                             int rows, int cols, long passes, uint64_t* checksum_out){
    uint64_t checksum = 0;

    auto start = std::chrono::steady_clock::now();
    for(long p = 0; p < passes; p++){
        checksum = traverse(array, rows, cols);
    }
    auto end = std::chrono::steady_clock::now();

    *checksum_out = checksum;
    return std::chrono::duration<double, std::milli>(end - start).count();
}

/******************************
 * Function: median
 *
 * Description: This function returns the median of a list of times.
 *
 * param values: list of values (copied, then sorted)
 *
 * return: double, median value
 *
 ******************************/
static double median(std::vector<double> values){
    std::sort(values.begin(), values.end());
    return values[values.size() / 2];
}

/******************************
 * Function: run_traversal_experiment
 *
 * Description: This function runs row-major and column-major traversal at every size in
 *  TRAVERSAL_SIZES and prints a results table. Arrays are allocated and initialized before
 *  timing; the order of the two traversals alternates each trial so neither always runs
 *  with a warmer cache.
 *
 * return: int, 1 if every checksum pair matched, 0 otherwise
 *
 ******************************/
int run_traversal_experiment(){
    CacheInfo cache = read_cache_info();
    bool all_match = true;

    std::cout << "==================================================================\n";
    std::cout << "Part 2: Memory Traversal Experiment (row-major vs. column-major)\n";
    std::cout << "==================================================================\n";
    print_cache_info(&cache);
    std::cout << "Element type: int32_t (4 B). Operation per element: checksum += element\n";
    std::cout << "Each trial sweeps the array ceil(" << TARGET_VISITS
              << " / elements) times; median of " << TRAVERSAL_TRIALS << " trials reported.\n\n";

    std::cout << "| Class  | Dimensions     | Elements    | Array size  | Fits in | Col stride | "
                 "Passes | Row-major ms | Col-major ms | Row ns/elem | Col ns/elem | "
                 "Row-major speedup | Checksum (both) | Match |\n";
    std::cout << "|--------|----------------|-------------|-------------|---------|------------|"
                 "--------|--------------|--------------|-------------|-------------|"
                 "-------------------|-----------------|-------|\n";

    for(const TraversalSize& size : TRAVERSAL_SIZES){
        long elements = (long)size.rows * size.cols;
        double bytes = (double)elements * sizeof(int32_t);
        long passes = std::max(1L, (TARGET_VISITS + elements - 1) / elements);

        // allocate and initialize every element before timing (also faults in every page)
        std::vector<int32_t> array(elements);
        for(long i = 0; i < elements; i++){
            array[i] = (int32_t)((i * 7 + 3) & 0xFF);
        }

        std::vector<double> row_times, col_times;
        uint64_t row_checksum = 0, col_checksum = 0;

        // untimed warmup of both orders
        time_traversal(traverse_row_major, array.data(), size.rows, size.cols, 1, &row_checksum);
        time_traversal(traverse_col_major, array.data(), size.rows, size.cols, 1, &col_checksum);

        for(int t = 0; t < TRAVERSAL_TRIALS; t++){
            // alternate which order runs first in each trial
            if(t % 2 == 0){
                row_times.push_back(time_traversal(traverse_row_major, array.data(), size.rows,
                                                   size.cols, passes, &row_checksum));
                col_times.push_back(time_traversal(traverse_col_major, array.data(), size.rows,
                                                   size.cols, passes, &col_checksum));
            } else {
                col_times.push_back(time_traversal(traverse_col_major, array.data(), size.rows,
                                                   size.cols, passes, &col_checksum));
                row_times.push_back(time_traversal(traverse_row_major, array.data(), size.rows,
                                                   size.cols, passes, &row_checksum));
            }
        }

        double row_ms = median(row_times);
        double col_ms = median(col_times);
        double visits = (double)elements * passes;
        bool match = (row_checksum == col_checksum);
        if(!match){all_match = false;}

        std::cout << std::fixed
                  << "| " << std::left << std::setw(6) << size.size_class << " | "
                  << std::setw(14) << (std::to_string(size.rows) + " x " + std::to_string(size.cols))
                  << " | " << std::right << std::setw(11) << elements
                  << " | " << std::setw(11) << format_bytes(bytes)
                  << " | " << std::setw(7) << fits_in(&cache, bytes)
                  << " | " << std::setw(8) << size.cols * (long)sizeof(int32_t) << " B"
                  << " | " << std::setw(6) << passes
                  << " | " << std::setw(12) << std::setprecision(2) << row_ms
                  << " | " << std::setw(12) << col_ms
                  << " | " << std::setw(11) << std::setprecision(3) << row_ms * 1e6 / visits
                  << " | " << std::setw(11) << col_ms * 1e6 / visits
                  << " | " << std::setw(16) << std::setprecision(2) << col_ms / row_ms << "x"
                  << " | " << std::setw(15) << row_checksum
                  << " | " << std::setw(5) << (match ? "yes" : "NO") << " |\n";
    }

    std::cout << "\nRow-major speedup = column-major time / row-major time (>1 means row-major is faster).\n";
    std::cout << "All checksums match: " << (all_match ? "yes" : "NO") << "\n";

    return all_match ? 1 : 0;
}
