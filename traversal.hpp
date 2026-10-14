/************************
 * File: traversal.hpp
 *
 * Description: This file is the header for the Part 2 row-major vs. column-major traversal
 *          experiment.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef TRAVERSAL_HPP
#define TRAVERSAL_HPP

#include <stdint.h>

uint64_t traverse_row_major(const int32_t* array, int rows, int cols);
uint64_t traverse_col_major(const int32_t* array, int rows, int cols);
int run_traversal_experiment();

#endif
