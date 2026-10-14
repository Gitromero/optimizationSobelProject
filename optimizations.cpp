/************************
 * File: optimizations.cpp
 *
 * Description: This file includes optimized alternatives for the grayscale conversion and
 *          Sobel gradient magnitude calculations. These functions use fixed-point integer
 *          arithmetic and an approximate gradient magnitude to reduce expensive operations.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <opencv2/opencv.hpp>
#include <stdint.h>
#include <cstdlib>
#include <cmath>

#include "video_driver.hpp"
#include "optimizations.hpp"

/******************************
 * Function: grayscale_fixed
 *
 * Description: This function grayscales the given rgb_frame using a fixed-point approximation
 *  of the ITU-R (BT.709) grayscale coefficients. A scale factor of 256 is used so division can
 *  be performed with an 8-bit right shift. The coefficients 54, 183, and 19 sum to 256.
 *
 * param rgb_frame: pointer to the RGB frame
 * param gray_frame: pointer to the gray frame
 *
 * return: cv::Mat*, pointer to grayscaled frame
 *
 ******************************/
cv::Mat* grayscale_fixed(cv::Mat* rgb_frame, cv::Mat* gray_frame){
    if(!rgb_frame || !gray_frame){return nullptr;}

    // BT.709 fixed-point approximation with scale = 256
    // B: 0.0722 * 256 ~= 19
    // G: 0.7152 * 256 ~= 183
    // R: 0.2126 * 256 ~= 54
    const uint16_t B_COEFF = 19;
    const uint16_t G_COEFF = 183;
    const uint16_t R_COEFF = 54;

    rgb_frame->copyTo(*gray_frame);

    cv::Vec3b pixel = 0;
    uint32_t gray_acc = 0;
    uint16_t gray = 0;

    // iterate through each pixel value in the frame
    for(int r = 0; r < gray_frame->rows; r++){
        for(int c = 0; c < gray_frame->cols; c++){
            // grab pixel at this coordinate
            pixel = (*gray_frame).at<cv::Vec3b>(r, c);

            // fixed-point grayscale calculation; +128 rounds before dividing by 256
            gray_acc = (pixel[0] * B_COEFF) +
                       (pixel[1] * G_COEFF) +
                       (pixel[2] * R_COEFF) + 128;
            gray = gray_acc >> 8;

            // write value back to BGR value in pixel vector
            (*gray_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(gray, gray, gray);
        }
    }

    return gray_frame;
}

/******************************
 * Function: gradient_magnitude_approx
 *
 * Description: This function approximates the Euclidean gradient magnitude produced by the
 *  Sobel Operator. Instead of sqrt(Gx^2 + Gy^2), it uses |Gx| + |Gy| to avoid multiplication
 *  and square-root operations. The result is bounded to an 8-bit pixel value.
 *
 * param x_acc: accumulated horizontal Sobel gradient Gx
 * param y_acc: accumulated vertical Sobel gradient Gy
 *
 * return: int, approximated gradient magnitude bounded from 0 to 255
 *
 ******************************/
int gradient_magnitude_approx(int x_acc, int y_acc){
    int final_mag = std::abs(x_acc) + std::abs(y_acc);

    if(final_mag > 255){final_mag = 255;}

    return final_mag;
}

/******************************
 * Function: conv_helper_approx
 *
 * Description: This helper applies the Gx and Gy Sobel matrices to the current pixel and its
 *  eight neighboring pixels. It uses the approximate gradient magnitude calculation instead
 *  of the Euclidean magnitude used by the baseline implementation.
 *
 * param r: measures number of rows
 * param c: measures number of columns
 * param gray_frame: pointer to the gray frame
 * param sobel_frame: pointer to the sobel frame
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int conv_helper_approx(int r, int c, cv::Mat* gray_frame, cv::Mat* sobel_frame){
    if(!gray_frame || !sobel_frame){return 0;}

    cv::Vec3b temp_pix;
    uint8_t row_idx = 0, col_idx = 0;
    int x_acc = 0, y_acc = 0;

    // iterate through neighboring pixels with Gx filter
    for(int a = -1; a < 2; a++){
        col_idx = 0;
        for(int b = -1; b < 2; b++){
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            x_acc += (temp_pix[0] * Gx[row_idx][col_idx]);
            col_idx++;
        }
        row_idx++;
    }

    // iterate through neighboring pixels with Gy filter
    row_idx = 0;
    col_idx = 0;
    for(int a = -1; a < 2; a++){
        col_idx = 0;
        for(int b = -1; b < 2; b++){
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            y_acc += (temp_pix[0] * Gy[row_idx][col_idx]);
            col_idx++;
        }
        row_idx++;
    }

    // use approximate gradient magnitude and save to center pixel
    int final_mag = gradient_magnitude_approx(x_acc, y_acc);
    (*sobel_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(final_mag, final_mag, final_mag);

    return 1;
}

/******************************
 * Function: sobel_approx
 *
 * Description: This function applies the Sobel Operator to the given gray frame using the
 *  approximate gradient magnitude calculation.
 *
 * param gray_frame: pointer to the gray frame
 *
 * return: cv::Mat*, pointer to new Sobel frame
 *
 ******************************/
cv::Mat* sobel_approx(cv::Mat* gray_frame){
    if(!gray_frame){return nullptr;}

    cv::Mat* sobel_frame = new cv::Mat();
    gray_frame->copyTo(*sobel_frame);

    // slide Gx and Gy filters across frame
    for(int r = 1; r < sobel_frame->rows - 1; r++){
        for(int c = 1; c < sobel_frame->cols - 1; c++){
            conv_helper_approx(r, c, gray_frame, sobel_frame);
        }
    }

    return sobel_frame;
}

/*==========================================================================================
 * Lab 3 baseline reference (float BT.709 grayscale, sqrt gradient magnitude). Used by the
 * Lab 4 driver to check that its baseline reproduces the Lab 3 arithmetic. Only change from
 * Lab 3: the Gy loop resets col_idx for every kernel row.
 *========================================================================================*/

/******************************
 * Function: conv_helper_lab3
 *
 * Description: This helper applies the Gx and Gy Sobel matrices to the current pixel and its
 *  eight neighboring pixels and writes the Euclidean gradient magnitude to the center pixel.
 *
 * param r: measures number of rows
 * param c: measures number of columns
 * param gray_frame: pointer to the gray frame
 * param sobel_frame: pointer to the sobel frame
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int conv_helper_lab3(int r, int c, cv::Mat* gray_frame, cv::Mat* sobel_frame){
    if(!gray_frame || !sobel_frame){return 0;}

    cv::Vec3b temp_pix;
    uint8_t row_idx = 0, col_idx = 0;
    int x_acc = 0, y_acc = 0;

    // iterate through neighboring pixels with Gx filter
    for(int a = -1; a < 2; a++){
        col_idx = 0;
        for(int b = -1; b < 2; b++){
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            x_acc += (temp_pix[0] * Gx[row_idx][col_idx]);
            col_idx++;
        }
        row_idx++;
    }

    // iterate through neighboring pixels with Gy filter
    row_idx = 0;
    for(int a = -1; a < 2; a++){
        col_idx = 0;    // Gy col_idx fix
        for(int b = -1; b < 2; b++){
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            y_acc += (temp_pix[0] * Gy[row_idx][col_idx]);
            col_idx++;
        }
        row_idx++;
    }

    // add x and y magnitude and bound check
    int final_mag = (x_acc * x_acc) + (y_acc * y_acc);
    final_mag = sqrt(final_mag);
    if(final_mag > 255){final_mag = 255;}

    // save back to center pixel on sobel frame
    (*sobel_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(final_mag, final_mag, final_mag);
    return 1;
}

/******************************
 * Function: sobel_lab3
 *
 * Description: This function applies the Sobel Operator to the given gray frame. The border
 *  keeps the gray value because the output starts as a copy of the gray frame.
 *
 * param gray_frame: pointer to the gray frame (CV_8UC3)
 *
 * return: cv::Mat*, pointer to new Sobel frame (caller deletes)
 *
 ******************************/
cv::Mat* sobel_lab3(cv::Mat* gray_frame){
    if(!gray_frame){return nullptr;}

    cv::Mat* sobel_frame = new cv::Mat();
    gray_frame->copyTo(*sobel_frame);

    // slide Gx and Gy filters across frame
    for(int r = 1; r < sobel_frame->rows - 1; r++){
        for(int c = 1; c < sobel_frame->cols - 1; c++){
            conv_helper_lab3(r, c, gray_frame, sobel_frame);
        }
    }
    return sobel_frame;
}

/******************************
 * Function: grayscale_lab3
 *
 * Description: This function grayscales the given rgb_frame by applying the
 *  ITU-R (BT.709) grayscale scalars.
 *
 * param rgb_frame: pointer to the BGR frame
 * param gray_frame: pointer to the gray frame (overwritten with a CV_8UC3 copy)
 *
 * return: cv::Mat*, pointer to grayscaled frame
 *
 ******************************/
cv::Mat* grayscale_lab3(cv::Mat* rgb_frame, cv::Mat* gray_frame){
    if(!rgb_frame || !gray_frame){return nullptr;}

    rgb_frame->copyTo(*gray_frame);

    cv::Vec3b pixel = 0;
    uint16_t gray = 0;

    // iterate through each pixel value in the frame
    for(int r = 0; r < gray_frame->rows; r++){
        for(int c = 0; c < gray_frame->cols; c++){
            pixel = (*gray_frame).at<cv::Vec3b>(r, c);

            // grayscale : gray = 0.2126(R) + 0.7152(G) + 0.0722(B)
            gray = (pixel[0] * 0.0722) + (pixel[1] * 0.7152) + (pixel[2] * 0.2126);
            gray > 255 ? gray = 255 : gray = gray;

            (*gray_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(gray, gray, gray);
        }
    }

    return gray_frame;
}
