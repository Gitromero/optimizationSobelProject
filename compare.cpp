/************************
 * File: compare.cpp
 *
 * Description: This file includes the output-image comparison used to verify that each
 *          memory optimization produces the same image as the baseline. The comparison is
 *          done by hand (row pointers, byte by byte) so it works for any channel count and
 *          for non-continuous images (ROIs with row padding).
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <opencv2/opencv.hpp>
#include <stdint.h>
#include <cstdlib>

#include "compare.hpp"

/******************************
 * Function: compare_images
 *
 * Description: This function compares two images pixel by pixel and reports how many pixels
 *  differ, the maximum absolute channel difference, and whether they are bit-for-bit equal.
 *
 * param image_a: pointer to the first image
 * param image_b: pointer to the second image
 *
 * return: ImageDiff, comparison summary (comparable = false if sizes/types differ)
 *
 ******************************/
ImageDiff compare_images(cv::Mat* image_a, cv::Mat* image_b){
    ImageDiff diff = {false, 0, 0, false};

    if(!image_a || !image_b){return diff;}
    if(image_a->rows != image_b->rows || image_a->cols != image_b->cols ||
       image_a->type() != image_b->type() || image_a->elemSize1() != 1){return diff;}

    diff.comparable = true;

    int channels = image_a->channels();
    int delta = 0;
    bool pixel_differs = false;

    // walk both images row by row through their own row pointers (stride-safe)
    for(int r = 0; r < image_a->rows; r++){
        const uint8_t* row_a = image_a->ptr<uint8_t>(r);
        const uint8_t* row_b = image_b->ptr<uint8_t>(r);

        for(int c = 0; c < image_a->cols; c++){
            pixel_differs = false;

            // check every channel of this pixel
            for(int ch = 0; ch < channels; ch++){
                delta = std::abs(row_a[c*channels + ch] - row_b[c*channels + ch]);
                if(delta != 0){pixel_differs = true;}
                if(delta > diff.max_abs_diff){diff.max_abs_diff = delta;}
            }

            if(pixel_differs){diff.differing_pixels++;}
        }
    }

    diff.identical = (diff.differing_pixels == 0);

    return diff;
}

/******************************
 * Function: accumulate_diff
 *
 * Description: This function folds one frame's comparison into a running multi-frame total.
 *
 * param total: pointer to the running total (initialize to {true, 0, 0, true})
 * param frame_diff: pointer to one frame's comparison result
 *
 * return: none
 *
 ******************************/
void accumulate_diff(ImageDiff* total, ImageDiff* frame_diff){
    if(!total || !frame_diff){return;}

    total->comparable = total->comparable && frame_diff->comparable;
    total->differing_pixels += frame_diff->differing_pixels;
    if(frame_diff->max_abs_diff > total->max_abs_diff){total->max_abs_diff = frame_diff->max_abs_diff;}
    total->identical = total->comparable && (total->differing_pixels == 0);
}
