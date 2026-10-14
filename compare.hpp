/************************
 * File: compare.hpp
 *
 * Description: This file is the header for the output-image comparison used to verify that
 *          every memory optimization preserves the baseline output.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef COMPARE_HPP
#define COMPARE_HPP

#include <opencv2/opencv.hpp>
#include <stdint.h>

struct ImageDiff {
    bool comparable;           // same size, type, and channel count
    long differing_pixels;     // pixels where any channel differs
    int max_abs_diff;          // largest |a - b| over all channels
    bool identical;            // comparable and zero differing pixels
};

ImageDiff compare_images(cv::Mat* image_a, cv::Mat* image_b);
void accumulate_diff(ImageDiff* total, ImageDiff* frame_diff);

#endif
