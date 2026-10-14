# Lab 5: Compiler Optimization Results

Resolution: 1920x1080 (median ms/frame; every resolution is in the per-part outputs)  
CPU: Cortex-A76, single thread  
Compiler: g++ (Debian 14.2.0-19) 14.2.0  
Samples: 1080 frames x 1 pass per resolution (+1 untimed warmup); one frame decoded at a time, outside the timed region; median per-frame time reported.  
Current implementation = Lab 4 full-frame row-pointer pipeline (grayscale_ptr / sobel_ptr).  
Lab 2 baseline = Lab 2 grayscale()/sobel() (grayscale_lab3 / sobel_lab3, Gy col_idx fix).

| Part | Build | Source | Grayscale (ms/frame) | Sobel (ms/frame) | Total (ms/frame) | Speedup vs -O0 (Lab 4 start) | Speedup vs Lab 2 -O3 |
|------|-------|--------|----------------------|------------------|------------------|------------------------------|----------------------|
| 1 | `-O0` | Current | 27.363 | 176.334 | 203.728 | 1.00x | 0.25x |
| 1 | `-O3 -fno-tree-loop-vectorize -fno-tree-slp-vectorize` | Current | 5.531 | 21.134 | 26.697 | 7.63x | 1.90x |
| 3 | `-O3` | Current | 3.489 | 21.101 | 24.599 | 8.28x | 2.06x |
| 4 | `-O3 -march=native` | Current | 3.614 | 21.131 | 24.762 | 8.23x | 2.04x |
| 5 | `-O3` | Lab 2 baseline | 11.409 | 39.174 | 50.620 | 4.02x | 1.00x |
| 5 | `-O3` | Current (Part 3 run reused) | 3.489 | 21.101 | 24.599 | 8.28x | 2.06x |

Speedups are total (grayscale + Sobel) time: (reference total) / (this row's total).

Output check (last frame vs. the -O0 current-implementation reference):

| Run output | Bit-identical to -O0 |
|------------|----------------------|
| output2/part1_O0.txt | n/a (this run is the reference) |
| output2/part1_O3_novec.txt | NO |
| output2/part3_O3.txt | NO |
| output2/part4_O3_native.txt | NO |
| output2/part5_lab2_O3.txt | NO |

Any -O3 difference is a compiler effect, not a source change: at -O3 GCC contracts the double
grayscale math in gray_value() (a*b + c) into fused multiply-adds (fmadd/fmla), which round once
instead of twice. A gray value that lands on an integer boundary can then truncate one level
differently, and the Sobel output inherits it. Rebuilding -O3 -fno-tree-loop-vectorize
-fno-tree-slp-vectorize with -ffp-contract=off made every output bit-identical to -O0 (checked
separately; not part of the five measured runs).
