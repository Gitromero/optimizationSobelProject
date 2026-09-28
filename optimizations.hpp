/************************
 * File: optimizations.hpp
 *
 * Description: This file is the header for the optimized grayscale and Sobel implementations.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef OPTIMIZATIONS_HPP
#define OPTIMIZATIONS_HPP

#include <opencv2/opencv.hpp>

cv::Mat* grayscale_fixed(cv::Mat* rgb_frame, cv::Mat* gray_frame);
int gradient_magnitude_approx(int x_acc, int y_acc);
int conv_helper_approx(int r, int c, cv::Mat* gray_frame, cv::Mat* sobel_frame);
cv::Mat* sobel_approx(cv::Mat* gray_frame);

#endif
