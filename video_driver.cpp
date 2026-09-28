/************************
 * File: video_driver.cpp
 * 
 * Description: This file includes all functionality for greyscaling and applying the 
 *          Sobel Operator to a video using the OpenCV library.
 * 
 * Author: Joshua Dagan
 * Email: jodagan@calpoly.edu
 * 
 * 
***************************/

#include <opencv2/opencv.hpp>
#include <iostream>
#include <cmath>
#include <cstdint>
#include <iomanip>

#include "video_driver.hpp"
#include "optimizations.hpp"

/* Spatial relation from middle pixel
top-left (r-1, c-1)   top-mid (r-1, c)     top-right (r-1, c+1)
mid-left (r, c-1)     mid-mid (r, c)       mid-right (r, c+1)
bot-left (r+1, c-1)   bot-mid (r+1, c)     bot-right (r+1, c+1)
*/

/******************************
 * Function: conv_helper
 * 
 * Description: This helper abstracts the matrix multiplication from the Sobel Operator function.
 *  It works by using the spacial relation between the current pixel (center pixel) and the 
 *  eight pixels around it to apply the Gx and Gy matrices of the Sobel Operator.
 * 
 * param r: measures number of rows
 * param c: measures number of columns
 * param gray_frame: pointer to the gray frame
 * param sobel_frame: pointer to the sobel frame
 * 
 * return: int, 1 on success, 0 on failure

******************************/

int conv_helper(int r, int c, cv::Mat* gray_frame, cv::Mat* sobel_frame){
    if(!gray_frame || !sobel_frame){return 0;}

    cv::Vec3b temp_pix;
    uint8_t row_idx = 0, col_idx = 0;
    int x_acc = 0, y_acc = 0;
    // iterate through neighboring pixels with Gx filter
    for(int a = -1; a < 2; a++){
        col_idx = 0;
        for(int b = -1; b < 2; b++){
            // grab temp pixel
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            // convolve with one BGR value (here we do blue) and accumulate
            x_acc += (temp_pix[0] * Gx[row_idx][col_idx]);
            // go to next column in Gx and neighbor
            col_idx ++;
        }
        // go to next row in Gx
        row_idx++;
    }

    // iterate through neighboring pixels with Gy filter
    row_idx = 0;
    col_idx = 0;
    for(int a = -1; a < 2; a++){
        for(int b = -1; b < 2; b++){
            // grab temp pixel
            temp_pix = (*gray_frame).at<cv::Vec3b>(r+a, c+b);
            // convolve with one BGR value (here, we do blue)
            y_acc += (temp_pix[0] * Gy[row_idx][col_idx]);
            // go to next col in Gy and neighbor (for-loop iterator)
            col_idx ++;
        }
        // go to next row in Gx
        row_idx++;
    }

    // add x and y magnitude and bound check
    int final_mag = (x_acc * x_acc) + (y_acc * y_acc);
    final_mag = sqrt(final_mag);
    // if(final_mag < 0){ final_mag = 0;} // not mathematically possible
    if(final_mag > 255){final_mag = 255;}

    // save back to center pixel on sobel frame
    (*sobel_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(final_mag, final_mag, final_mag);
    return 1;
}

/******************************
 * Function: sobel
 * 
 * Description: This function applies the Sobel Operator to the given gray frame cv::Mat* file
 * 
 * param gray_frame: pointer to the gray frame
 * 
 * return: int, 1 on success, 0 on failure

******************************/
cv::Mat* sobel(cv::Mat* gray_frame){
    // copying gray frame into sobel (mainly for constant sizing)
    cv::Mat* sobel_frame = new cv::Mat();
    gray_frame->copyTo(*sobel_frame);

    // need to slide Gx and Gy filters across frame
    for(int r = 1; r < sobel_frame->rows - 1; r++){
        for(int c = 1; c < sobel_frame->cols - 1; c++){
            // send r, c, and cur_pixel to conv func and apply Gx and Gy
            conv_helper(r, c, gray_frame, sobel_frame);
        }
    }
    return sobel_frame;
}

/******************************
 * Function: greyscale
 * 
 * Description: This function greyscales the given rgb_frame by applying the 
 *  ITU-R (BT.709) greyscale scalars
 * 
 * param rgb_frame: pointer to the sobel frame
 * param gray_frame: pointer to the gray frame
 * 
 * return: cv::Mat*, pointer to new grayscaled frame

******************************/
cv::Mat* grayscale(cv::Mat* rgb_frame, cv::Mat* gray_frame){
    // grayscale : gray = 0.2126(R) + 0.7152(G) + 0.0722(B)
    // pixel[0] = blue, pixel[1] = green, pixel[2] = red

    // copy rgb frame to gray frame pointer
    rgb_frame->copyTo(*gray_frame);

    cv::Vec3b pixel = 0;
    uint16_t gray = 0;

    // iterate through each pixel value in the frame
    for(int r = 0; r < gray_frame->rows; r++){
        for(int c = 0; c < gray_frame->cols; c++){
            // grab pixel at this coordinate
            pixel = (*gray_frame).at<cv::Vec3b>(r, c);

            // calculate the gray value, bound check
            gray = ((pixel)[0] * 0.0722) + ((pixel)[1] * 0.7152) + ((pixel)[2] * 0.2126); // blue, green, red
            gray > 255 ? gray = 255 : gray = gray;
            
            // write value back to BGR value in pixel vector
            (*gray_frame).at<cv::Vec3b>(r, c) = cv::Vec3b(gray, gray, gray);
        }
    }

    return gray_frame;
}

/******************************
 * Function: main
 * 
 * Description: opens files, manages different frame types, displays frames 
 * 
 * return: int, 1 on success, 0 on failure

******************************/
int main(int argc, char *argv[]){
    if(argc != 2){
        std::cout << "Usage: " << argv[0] << " <video>" << std::endl;
        return -1;
    }

    const char* video_file = argv[1];
    cv::VideoCapture cap(video_file);

    if(!cap.isOpened()){
        std::cout << "Error: couldn't open file: " << video_file << std::endl;
        return -1;
    }

    // Use a later frame so the comparison is not taken from the black intro.
    const int comparison_frame = 60;
    cap.set(cv::CAP_PROP_POS_FRAMES, comparison_frame);

    cv::Mat rgb_frame;
    cv::Mat gray_frame;

    if(!cap.read(rgb_frame)){
        std::cout << "Error: couldn't read frame " << comparison_frame << std::endl;
        return -1;
    }

    // Both Sobel versions use the same grayscale frame so the only difference
    // in the saved images is exact vs. approximate gradient magnitude.
    grayscale(&rgb_frame, &gray_frame);

    cv::Mat* exact_frame = sobel(&gray_frame);
    cv::Mat* approx_frame = sobel_approx(&gray_frame);

    cv::imwrite("sobel_exact.png", *exact_frame);
    cv::imwrite("sobel_approx.png", *approx_frame);

    delete exact_frame;
    delete approx_frame;
    cap.release();

    std::cout << "Saved comparison images from frame " << comparison_frame << ":\n";
    std::cout << "  sobel_exact.png\n";
    std::cout << "  sobel_approx.png\n";

    return 0;
}
