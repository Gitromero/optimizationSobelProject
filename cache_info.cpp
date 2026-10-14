/************************
 * File: cache_info.cpp
 *
 * Description: This file reads the L1 data, L2, and L3 cache sizes and the cache-line size
 *          from /sys/devices/system/cpu/cpu0/cache and formats byte counts for reports.
 *          Falls back to the i5-9300H values (32K / 256K / 8M / 64B) if sysfs is unavailable.
 *
 * Author: Diego Romero
 *
 *
 ***************************/

#include <fstream>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <string>

#include "cache_info.hpp"

/******************************
 * Function: read_sysfs_size
 *
 * Description: This function reads a sysfs cache size string such as "32K" or "8192K".
 *
 * param path: sysfs file path
 * param fallback: value returned if the file cannot be read
 *
 * return: long, size in bytes
 *
 ******************************/
static long read_sysfs_size(const std::string& path, long fallback){
    std::ifstream file(path);
    std::string text;
    if(!(file >> text) || text.empty()){return fallback;}

    long value = std::stol(text);
    char suffix = text.back();
    if(suffix == 'K'){value *= 1024;}
    if(suffix == 'M'){value *= 1024 * 1024;}

    return value;
}

/******************************
 * Function: read_cache_info
 *
 * Description: This function reads cpu0's cache hierarchy from sysfs.
 *
 * return: CacheInfo, cache sizes in bytes
 *
 ******************************/
CacheInfo read_cache_info(){
    const std::string base = "/sys/devices/system/cpu/cpu0/cache/";
    CacheInfo info;

    // index0 = L1 data, index1 = L1 instruction, index2 = L2, index3 = L3
    info.l1d_bytes = read_sysfs_size(base + "index0/size", 32L * 1024);
    info.l2_bytes = read_sysfs_size(base + "index2/size", 256L * 1024);
    info.l3_bytes = read_sysfs_size(base + "index3/size", 8L * 1024 * 1024);
    info.line_bytes = read_sysfs_size(base + "index0/coherency_line_size", 64);

    return info;
}

/******************************
 * Function: print_cache_info
 *
 * Description: This function prints the cache hierarchy used to interpret the results.
 *
 * param info: pointer to cache info
 *
 * return: none
 *
 ******************************/
void print_cache_info(CacheInfo* info){
    if(!info){return;}

    std::cout << "Cache hierarchy (cpu0): L1d " << format_bytes(info->l1d_bytes)
              << ", L2 " << format_bytes(info->l2_bytes)
              << ", L3 " << format_bytes(info->l3_bytes)
              << ", line " << info->line_bytes << " B\n";
}

/******************************
 * Function: fits_in
 *
 * Description: This function names the smallest cache level a working set fits in.
 *
 * param info: pointer to cache info
 * param bytes: working-set size in bytes
 *
 * return: std::string, "L1", "L2", "L3", or "DRAM"
 *
 ******************************/
std::string fits_in(CacheInfo* info, double bytes){
    if(!info){return "?";}
    if(bytes <= info->l1d_bytes){return "L1";}
    if(bytes <= info->l2_bytes){return "L2";}
    if(bytes <= info->l3_bytes){return "L3";}
    return "DRAM";
}

/******************************
 * Function: format_bytes
 *
 * Description: This function formats a byte count as B / KiB / MiB with one decimal.
 *
 * param bytes: byte count
 *
 * return: std::string, formatted size
 *
 ******************************/
std::string format_bytes(double bytes){
    std::ostringstream out;
    out << std::fixed << std::setprecision(1);

    if(bytes < 1024.0){out << bytes << " B";}
    else if(bytes < 1024.0 * 1024.0){out << bytes / 1024.0 << " KiB";}
    else{out << bytes / (1024.0 * 1024.0) << " MiB";}

    return out.str();
}
