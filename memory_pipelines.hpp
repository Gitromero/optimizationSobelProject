/************************
 * File: memory_pipelines.hpp
 *
 * Description: This file is the header for the Lab 4 grayscale + Sobel pipelines. All three
 *          pipelines use the Lab 3 baseline arithmetic and differ only in how memory is
 *          accessed:
 *              - full-frame, cv::Mat::at() per pixel      (Part 1 baseline / Part 3)
 *              - full-frame, row pointers from ptr()      (Part 3)
 *              - three-row streaming buffer               (Part 5)
 *
 *          Every buffer is allocated by the caller before the timed region; these functions
 *          never allocate.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef MEMORY_PIPELINES_HPP
#define MEMORY_PIPELINES_HPP

#include <opencv2/opencv.hpp>
#include <stdint.h>

// shared arithmetic
uint8_t gray_value(uint8_t blue, uint8_t green, uint8_t red);
uint8_t gradient_magnitude(int x_acc, int y_acc);

// full-frame pipeline, cv::Mat::at() access
int grayscale_at(cv::Mat* rgb_frame, cv::Mat* gray_frame);
int sobel_at(cv::Mat* gray_frame, cv::Mat* sobel_frame);

// full-frame pipeline, row-pointer access
void grayscale_row_ptr(const uint8_t* rgb_row, uint8_t* gray_row, int cols);
void sobel_row_ptr(const uint8_t* above, const uint8_t* current, const uint8_t* below,
                   uint8_t* sobel_row, int cols);
void zero_row_ptr(uint8_t* row, int cols);
int grayscale_ptr(cv::Mat* rgb_frame, cv::Mat* gray_frame);
int sobel_ptr(cv::Mat* gray_frame, cv::Mat* sobel_frame);

// three-row streaming pipeline
int sobel_streaming(cv::Mat* rgb_frame, cv::Mat* row_buffers, cv::Mat* sobel_frame);

#endif
