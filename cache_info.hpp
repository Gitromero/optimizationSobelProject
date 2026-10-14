/************************
 * File: cache_info.hpp
 *
 * Description: This file is the header for reading the processor's cache sizes (Linux sysfs)
 *          so experiment output can state which cache level a working set fits in.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#ifndef CACHE_INFO_HPP
#define CACHE_INFO_HPP

#include <string>

struct CacheInfo {
    long l1d_bytes;
    long l2_bytes;
    long l3_bytes;
    long line_bytes;
};

CacheInfo read_cache_info();
void print_cache_info(CacheInfo* info);
std::string fits_in(CacheInfo* info, double bytes);
std::string format_bytes(double bytes);

#endif
