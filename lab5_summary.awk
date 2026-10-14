#************************
# File: lab5_summary.awk
#
# Description: This script builds the Lab 5 summary table (<dir>/lab5_summary.md) from the
#          five Lab 5 run outputs. It reads the timing row of one resolution from each run and
#          reports grayscale, Sobel, and total time, plus the total speedup relative to the
#          -O0 current implementation (Lab 4 starting point) and the Lab 2 baseline at -O3.
#          Part 5's "current implementation, -O3" row reuses the Part 3 -O3 run (same binary,
#          same source, same flags) instead of measuring it a second time.
#
#          Usage (from the Makefile):
#              awk -v res=1920x1080 -v cpu="..." -v compiler="..." -v dir=output2 \
#                  -f lab5_summary.awk output2/part1_O0.txt output2/part1_O3_novec.txt \
#                  output2/part3_O3.txt output2/part4_O3_native.txt output2/part5_lab2_O3.txt
#
# Author: Diego Romero
#
#
#**************************

# grab the first timing row of the requested resolution in each file
# columns: | Resolution | Pixels | Gray ms/frame | Sobel ms/frame | Total ms/frame | ns/pixel | FPS |
$0 ~ "^\\| " res " \\|" && !(FILENAME in total){
    split($0, f, "|")
    gray[FILENAME] = f[4] + 0
    sobel[FILENAME] = f[5] + 0
    total[FILENAME] = f[6] + 0
}

/^Samples:/ && samples == ""{samples = $0}
/^All outputs bit-identical:/{
    check[FILENAME] = $0
    sub(/^All outputs bit-identical: /, "", check[FILENAME])
}

function row(part, build, source, file, note){
    if(!(file in total)){
        printf "| %s | %s | %s | missing (%s) | | | | |\n", part, build, source, file
        return
    }
    printf "| %s | `%s` | %s%s | %.3f | %.3f | %.3f | %.2fx | %.2fx |\n", part, build, source, note,
           gray[file], sobel[file], total[file], total[O0] / total[file], total[LAB2] / total[file]
}

END{
    O0 = dir "/part1_O0.txt"
    NOVEC = dir "/part1_O3_novec.txt"
    O3 = dir "/part3_O3.txt"
    NATIVE = dir "/part4_O3_native.txt"
    LAB2 = dir "/part5_lab2_O3.txt"

    print "# Lab 5: Compiler Optimization Results"
    print ""
    print "Resolution: " res " (median ms/frame; every resolution is in the per-part outputs)  "
    print "CPU: " cpu ", single thread  "
    print "Compiler: " compiler "  "
    print samples "  "
    print "Current implementation = Lab 4 full-frame row-pointer pipeline (grayscale_ptr / sobel_ptr).  "
    print "Lab 2 baseline = Lab 2 grayscale()/sobel() (grayscale_lab3 / sobel_lab3, Gy col_idx fix)."
    print ""
    print "| Part | Build | Source | Grayscale (ms/frame) | Sobel (ms/frame) | Total (ms/frame) | Speedup vs -O0 (Lab 4 start) | Speedup vs Lab 2 -O3 |"
    print "|------|-------|--------|----------------------|------------------|------------------|------------------------------|----------------------|"
    row("1", "-O0", "Current", O0, "")
    row("1", "-O3 -fno-tree-loop-vectorize -fno-tree-slp-vectorize", "Current", NOVEC, "")
    row("3", "-O3", "Current", O3, "")
    row("4", "-O3 -march=native", "Current", NATIVE, "")
    row("5", "-O3", "Lab 2 baseline", LAB2, "")
    row("5", "-O3", "Current", O3, " (Part 3 run reused)")
    print ""
    print "Speedups are total (grayscale + Sobel) time: (reference total) / (this row's total)."
    print ""
    print "Output check (last frame vs. the -O0 current-implementation reference):"
    print ""
    print "| Run output | Bit-identical to -O0 |"
    print "|------------|----------------------|"
    printf "| %s | %s |\n", O0, check[O0]
    printf "| %s | %s |\n", NOVEC, check[NOVEC]
    printf "| %s | %s |\n", O3, check[O3]
    printf "| %s | %s |\n", NATIVE, check[NATIVE]
    printf "| %s | %s |\n", LAB2, check[LAB2]
    print ""
    print "Any -O3 difference is a compiler effect, not a source change: at -O3 GCC contracts the double"
    print "grayscale math in gray_value() (a*b + c) into fused multiply-adds (fmadd/fmla), which round once"
    print "instead of twice. A gray value that lands on an integer boundary can then truncate one level"
    print "differently, and the Sobel output inherits it. Rebuilding -O3 -fno-tree-loop-vectorize"
    print "-fno-tree-slp-vectorize with -ffp-contract=off made every output bit-identical to -O0 (checked"
    print "separately; not part of the five measured runs)."
}
