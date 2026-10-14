/************************
 * File: memory_pipelines.cpp
 *
 * Description: This file includes the Lab 4 grayscale + Sobel pipelines. The arithmetic is
 *          the Lab 3 baseline (floating-point BT.709 grayscale, sqrt gradient magnitude) and
 *          is identical in every version; only the memory access pattern changes.
 *
 *          Image format for every version:
 *              rgb_frame   : CV_8UC3 (BGR), read only
 *              gray_frame  : CV_8UC1, one byte per pixel
 *              sobel_frame : CV_8UC1, one byte per pixel
 *              row_buffers : CV_8UC1 with 3 rows (streaming only)
 *
 *          Border policy (all versions): the first/last row and first/last column of the
 *          Sobel frame do not have a full 3x3 neighborhood and are written as 0.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <opencv2/opencv.hpp>
#include <stdint.h>
#include <cmath>

#include "video_driver.hpp"
#include "memory_pipelines.hpp"

/* Spatial relation from middle pixel
top-left (r-1, c-1)   top-mid (r-1, c)     top-right (r-1, c+1)
mid-left (r, c-1)     mid-mid (r, c)       mid-right (r, c+1)
bot-left (r+1, c-1)   bot-mid (r+1, c)     bot-right (r+1, c+1)
*/

/******************************
 * Function: gray_value
 *
 * Description: This function applies the ITU-R (BT.709) grayscale scalars to one BGR pixel.
 *  The expression, evaluation order, and truncation are copied from the Lab 3 baseline
 *  grayscale() so every Lab 4 pipeline produces the same grayscale values as Lab 3.
 *
 * param blue: blue channel (pixel[0])
 * param green: green channel (pixel[1])
 * param red: red channel (pixel[2])
 *
 * return: uint8_t, gray value bounded from 0 to 255
 *
 ******************************/
uint8_t gray_value(uint8_t blue, uint8_t green, uint8_t red){
    // grayscale : gray = 0.2126(R) + 0.7152(G) + 0.0722(B)
    uint16_t gray = (blue * 0.0722) + (green * 0.7152) + (red * 0.2126);
    gray > 255 ? gray = 255 : gray = gray;

    return gray;
}

/******************************
 * Function: gradient_magnitude
 *
 * Description: This function computes the Euclidean Sobel gradient magnitude exactly like
 *  the Lab 3 baseline conv_helper(): integer sum of squares, sqrt, truncate, bound to 255.
 *
 * param x_acc: accumulated horizontal Sobel gradient Gx
 * param y_acc: accumulated vertical Sobel gradient Gy
 *
 * return: uint8_t, gradient magnitude bounded from 0 to 255
 *
 ******************************/
uint8_t gradient_magnitude(int x_acc, int y_acc){
    // add x and y magnitude and bound check
    int final_mag = (x_acc * x_acc) + (y_acc * y_acc);
    final_mag = sqrt(final_mag);
    if(final_mag > 255){final_mag = 255;}

    return final_mag;
}

/*==========================================================================================
 * Full-frame pipeline, cv::Mat::at() access (Part 1 baseline, Part 3)
 *========================================================================================*/

/******************************
 * Function: grayscale_at
 *
 * Description: This function grayscales the full rgb_frame into gray_frame, reading and
 *  writing every pixel through cv::Mat::at(). This is the Lab 3 grayscale() access pattern,
 *  but the output is a single-channel image instead of a copied three-channel image.
 *
 * param rgb_frame: pointer to the BGR frame (CV_8UC3)
 * param gray_frame: pointer to the preallocated gray frame (CV_8UC1, same size)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int grayscale_at(cv::Mat* rgb_frame, cv::Mat* gray_frame){
    if(!rgb_frame || !gray_frame){return 0;}

    cv::Vec3b pixel = 0;

    // iterate through each pixel value in the frame (row-major)
    for(int r = 0; r < rgb_frame->rows; r++){
        for(int c = 0; c < rgb_frame->cols; c++){
            // grab pixel at this coordinate
            pixel = (*rgb_frame).at<cv::Vec3b>(r, c);

            // calculate the gray value and write it to the single-channel frame
            (*gray_frame).at<uint8_t>(r, c) = gray_value(pixel[0], pixel[1], pixel[2]);
        }
    }

    return 1;
}

/******************************
 * Function: sobel_at
 *
 * Description: This function applies the Sobel Operator to the full gray_frame. Every
 *  neighbor read and every output write goes through cv::Mat::at(). The kernel loop is the
 *  same shape as sobel_row_ptr() so the only difference between the two is pixel access.
 *
 * param gray_frame: pointer to the gray frame (CV_8UC1)
 * param sobel_frame: pointer to the preallocated sobel frame (CV_8UC1, same size)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int sobel_at(cv::Mat* gray_frame, cv::Mat* sobel_frame){
    if(!gray_frame || !sobel_frame){return 0;}

    int rows = gray_frame->rows;
    int cols = gray_frame->cols;
    uint8_t pixel = 0;
    int x_acc = 0, y_acc = 0;

    // frames too small for a 3x3 neighborhood are all border
    if(rows < 3 || cols < 3){
        for(int r = 0; r < rows; r++){
            for(int c = 0; c < cols; c++){(*sobel_frame).at<uint8_t>(r, c) = 0;}
        }
        return 1;
    }

    // top and bottom border rows
    for(int c = 0; c < cols; c++){
        (*sobel_frame).at<uint8_t>(0, c) = 0;
        (*sobel_frame).at<uint8_t>(rows - 1, c) = 0;
    }

    // slide Gx and Gy filters across frame
    for(int r = 1; r < rows - 1; r++){
        // left border pixel
        (*sobel_frame).at<uint8_t>(r, 0) = 0;

        for(int c = 1; c < cols - 1; c++){
            x_acc = 0;
            y_acc = 0;

            // iterate through the 3x3 neighborhood, applying Gx and Gy together
            for(int a = 0; a < 3; a++){
                for(int b = 0; b < 3; b++){
                    pixel = (*gray_frame).at<uint8_t>(r + a - 1, c + b - 1);
                    x_acc += (pixel * Gx[a][b]);
                    y_acc += (pixel * Gy[a][b]);
                }
            }

            // save back to center pixel on sobel frame
            (*sobel_frame).at<uint8_t>(r, c) = gradient_magnitude(x_acc, y_acc);
        }

        // right border pixel
        (*sobel_frame).at<uint8_t>(r, cols - 1) = 0;
    }

    return 1;
}

/*==========================================================================================
 * Full-frame pipeline, row-pointer access (Part 3)
 *
 * The row helpers below are also the building blocks of the streaming pipeline, so the
 * streaming version runs the exact same per-row code and only changes where rows live.
 *========================================================================================*/

/******************************
 * Function: grayscale_row_ptr
 *
 * Description: This function grayscales one row. The BGR row is read through a byte pointer:
 *  pixel c occupies bytes [3c, 3c+1, 3c+2] = [blue, green, red].
 *
 * param rgb_row: pointer to the first byte of a BGR row
 * param gray_row: pointer to the first byte of the output gray row
 * param cols: number of pixels in the row
 *
 * return: none
 *
 ******************************/
void grayscale_row_ptr(const uint8_t* rgb_row, uint8_t* gray_row, int cols){
    for(int c = 0; c < cols; c++){
        gray_row[c] = gray_value(rgb_row[3*c], rgb_row[3*c + 1], rgb_row[3*c + 2]);
    }
}

/******************************
 * Function: sobel_row_ptr
 *
 * Description: This function computes one Sobel output row from the three gray rows that
 *  surround it. The rows can live anywhere (a full gray frame or a 3-row buffer).
 *
 * param above: gray row r-1
 * param current: gray row r
 * param below: gray row r+1
 * param sobel_row: output row r
 * param cols: number of pixels in each row
 *
 * return: none
 *
 ******************************/
void sobel_row_ptr(const uint8_t* above, const uint8_t* current, const uint8_t* below,
                   uint8_t* sobel_row, int cols){
    const uint8_t* window[3] = {above, current, below};
    uint8_t pixel = 0;
    int x_acc = 0, y_acc = 0;

    // left border pixel
    sobel_row[0] = 0;

    for(int c = 1; c < cols - 1; c++){
        x_acc = 0;
        y_acc = 0;

        // iterate through the 3x3 neighborhood, applying Gx and Gy together
        for(int a = 0; a < 3; a++){
            for(int b = 0; b < 3; b++){
                pixel = window[a][c + b - 1];
                x_acc += (pixel * Gx[a][b]);
                y_acc += (pixel * Gy[a][b]);
            }
        }

        // save back to center pixel on sobel row
        sobel_row[c] = gradient_magnitude(x_acc, y_acc);
    }

    // right border pixel
    sobel_row[cols - 1] = 0;
}

/******************************
 * Function: zero_row_ptr
 *
 * Description: This function writes 0 to every pixel of a border row.
 *
 * param row: pointer to the first byte of the row
 * param cols: number of pixels in the row
 *
 * return: none
 *
 ******************************/
void zero_row_ptr(uint8_t* row, int cols){
    for(int c = 0; c < cols; c++){
        row[c] = 0;
    }
}

/******************************
 * Function: grayscale_ptr
 *
 * Description: This function grayscales the full rgb_frame into gray_frame. Each row is
 *  fetched once through ptr(), so row padding (step) is respected, and pixels are then
 *  indexed directly from the row pointer.
 *
 * param rgb_frame: pointer to the BGR frame (CV_8UC3)
 * param gray_frame: pointer to the preallocated gray frame (CV_8UC1, same size)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int grayscale_ptr(cv::Mat* rgb_frame, cv::Mat* gray_frame){
    if(!rgb_frame || !gray_frame){return 0;}

    for(int r = 0; r < rgb_frame->rows; r++){
        grayscale_row_ptr(rgb_frame->ptr<uint8_t>(r), gray_frame->ptr<uint8_t>(r),
                          rgb_frame->cols);
    }

    return 1;
}

/******************************
 * Function: sobel_ptr
 *
 * Description: This function applies the Sobel Operator to the full gray_frame using row
 *  pointers for the three input rows and the output row.
 *
 * param gray_frame: pointer to the gray frame (CV_8UC1)
 * param sobel_frame: pointer to the preallocated sobel frame (CV_8UC1, same size)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int sobel_ptr(cv::Mat* gray_frame, cv::Mat* sobel_frame){
    if(!gray_frame || !sobel_frame){return 0;}

    int rows = gray_frame->rows;
    int cols = gray_frame->cols;

    // frames too small for a 3x3 neighborhood are all border
    if(rows < 3 || cols < 3){
        for(int r = 0; r < rows; r++){zero_row_ptr(sobel_frame->ptr<uint8_t>(r), cols);}
        return 1;
    }

    // top and bottom border rows
    zero_row_ptr(sobel_frame->ptr<uint8_t>(0), cols);
    zero_row_ptr(sobel_frame->ptr<uint8_t>(rows - 1), cols);

    // slide Gx and Gy filters across frame one output row at a time
    for(int r = 1; r < rows - 1; r++){
        sobel_row_ptr(gray_frame->ptr<uint8_t>(r - 1),
                      gray_frame->ptr<uint8_t>(r),
                      gray_frame->ptr<uint8_t>(r + 1),
                      sobel_frame->ptr<uint8_t>(r), cols);
    }

    return 1;
}

/*==========================================================================================
 * Three-row streaming pipeline (Part 5)
 *========================================================================================*/

/******************************
 * Function: sobel_streaming
 *
 * Description: This function fuses grayscale and Sobel. Instead of writing a full gray
 *  frame, it keeps only three gray rows in row_buffers and produces one Sobel row as soon
 *  as the gray row below it exists:
 *
 *      color rows -> three gray row buffers -> Sobel output row
 *
 *  The three buffers rotate logically (pointer swap, no copying). After output row r is
 *  finished, gray row r-1 is never needed again, so its buffer receives gray row r+2.
 *
 *      step            above   current   below
 *      prime           g0      g1        -
 *      out row 1       g0      g1        g2      (g2 converted into the free buffer)
 *      rotate          g1      g2        [old g0 buffer, free]
 *      out row 2       g1      g2        g3
 *      ...
 *
 * param rgb_frame: pointer to the BGR frame (CV_8UC3)
 * param row_buffers: pointer to a preallocated 3-row gray buffer (CV_8UC1, 3 x cols)
 * param sobel_frame: pointer to the preallocated sobel frame (CV_8UC1, same size as rgb)
 *
 * return: int, 1 on success, 0 on failure
 *
 ******************************/
int sobel_streaming(cv::Mat* rgb_frame, cv::Mat* row_buffers, cv::Mat* sobel_frame){
    if(!rgb_frame || !row_buffers || !sobel_frame){return 0;}
    if(row_buffers->rows < 3 || row_buffers->cols < rgb_frame->cols){return 0;}

    int rows = rgb_frame->rows;
    int cols = rgb_frame->cols;

    // frames too small for a 3x3 neighborhood are all border
    if(rows < 3 || cols < 3){
        for(int r = 0; r < rows; r++){zero_row_ptr(sobel_frame->ptr<uint8_t>(r), cols);}
        return 1;
    }

    // logical names for the three physical row buffers
    uint8_t* above = row_buffers->ptr<uint8_t>(0);
    uint8_t* current = row_buffers->ptr<uint8_t>(1);
    uint8_t* below = row_buffers->ptr<uint8_t>(2);
    uint8_t* oldest = nullptr;

    // prime the window with gray rows 0 and 1
    grayscale_row_ptr(rgb_frame->ptr<uint8_t>(0), above, cols);
    grayscale_row_ptr(rgb_frame->ptr<uint8_t>(1), current, cols);

    // top border row
    zero_row_ptr(sobel_frame->ptr<uint8_t>(0), cols);

    for(int r = 1; r < rows - 1; r++){
        // produce the gray row below the output row into the free buffer
        grayscale_row_ptr(rgb_frame->ptr<uint8_t>(r + 1), below, cols);

        // consume the three gray rows while they are still in cache
        sobel_row_ptr(above, current, below, sobel_frame->ptr<uint8_t>(r), cols);

        // rotate: gray row r-1 is dead, its buffer becomes the next write target
        oldest = above;
        above = current;
        current = below;
        below = oldest;
    }

    // bottom border row
    zero_row_ptr(sobel_frame->ptr<uint8_t>(rows - 1), cols);

    return 1;
}
