/************************
 * File: video_driver.hpp
 *
 * Description: Shared Sobel kernels and experiment settings for Lab 4. The kernels are
 *          unchanged from Lab 3 so every Lab 4 implementation uses the same arithmetic.
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
const int BENCH_FRAMES = 120;

// index (within the test window) of the frame saved to captures/: the last test frame
const int CAPTURE_INDEX = BENCH_FRAMES - 1;
const int CAPTURE_FRAME = START_FRAME + CAPTURE_INDEX;

// number of times each implementation re-processes the BENCH_FRAMES frames
const int BENCH_REPEATS = 3;

// directory where image captures are written (relative to lab4/)
const char* const CAPTURE_DIR = "captures";

#endif
