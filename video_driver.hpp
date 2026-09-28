#ifndef VIDEO_DRIVER_HPP
#define VIDEO_DRIVER_HPP

#include <stdint.h>

inline int8_t Gx[3][3] = {
    {-1, 0, 1},
    {-2, 0, 2},
    {-1, 0, 1}
};

inline int8_t Gy[3][3] = {
    {1, 2, 1},
    {0, 0, 0},
    {-1, -2, -1}
};

#endif