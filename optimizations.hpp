/************************
 * File: optimizations.hpp
 *
 * Description: This file is the header for the optimized grayscale and Sobel implementations
 *          and the Lab 3 baseline reference used by the Lab 4 driver.
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

// Lab 3 baseline reference
int conv_helper_lab3(int r, int c, cv::Mat* gray_frame, cv::Mat* sobel_frame);
cv::Mat* sobel_lab3(cv::Mat* gray_frame);
cv::Mat* grayscale_lab3(cv::Mat* rgb_frame, cv::Mat* gray_frame);

#endif
