# bash with pipefail so a failing run is not hidden by "| tee"
SHELL := /bin/bash
.SHELLFLAGS := -o pipefail -c

CXX := g++
CXXFLAGS := -std=c++17 -g -O0 -Wall -Wextra $(shell pkg-config --cflags opencv4)
LDLIBS := $(shell pkg-config --libs opencv4) -lm

TARGET := video_driver
SOURCES := video_driver.cpp memory_pipelines.cpp compare.cpp optimizations.cpp \
           traversal.cpp cache_info.cpp
HEADERS := video_driver.hpp memory_pipelines.hpp compare.hpp optimizations.hpp \
           traversal.hpp cache_info.hpp

# 4K source video (same one used in Labs 2 and 3)
VIDEO ?= ../bbb_sunflower_2160p_60fps_normal.mp4

.PHONY: all clean run quick part1 part2 part3 part4 part5 \
        lab5 lab5_part1 lab5_part2 lab5_part3 lab5_part4 lab5_part5 lab5_summary

all: $(TARGET)

# run every part in order; part1 must run before part3/part5 (they compare to its captures)
run: part1 part2 part3 part4 part5

# each part tees its stdout into outputs/ so the .txt matches what was printed
part1: $(TARGET)
	@mkdir -p outputs captures
	./$(TARGET) part1 $(VIDEO) | tee outputs/part1_baseline.txt

part2: $(TARGET)
	@mkdir -p outputs
	./$(TARGET) part2 | tee outputs/part2_traversal.txt

part3: $(TARGET)
	@mkdir -p outputs captures
	./$(TARGET) part3 $(VIDEO) | tee outputs/part3_pixel_access.txt

part4: $(TARGET)
	@mkdir -p outputs
	./$(TARGET) part4 | tee outputs/part4_data_movement.txt

part5: $(TARGET)
	@mkdir -p outputs captures
	./$(TARGET) part5 $(VIDEO) | tee outputs/part5_6_streaming.txt

# smoke test: one frame, one repeat, every part; captures/ is written as usual, stdout is
# not saved to outputs/ so the real results stay untouched
QUICK_TARGET := $(TARGET)_quick

quick: $(QUICK_TARGET)
	@mkdir -p captures
	./$(QUICK_TARGET) part1 $(VIDEO)
	./$(QUICK_TARGET) part2
	./$(QUICK_TARGET) part3 $(VIDEO)
	./$(QUICK_TARGET) part4
	./$(QUICK_TARGET) part5 $(VIDEO)

$(QUICK_TARGET): $(SOURCES) $(HEADERS)
	$(CXX) $(CXXFLAGS) -DBENCH_FRAMES_N=1 -DBENCH_REPEATS_N=1 $(SOURCES) -o $@ $(LDLIBS)

$(TARGET): $(SOURCES) $(HEADERS)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $@ $(LDLIBS)

#==========================================================================================
# Lab 5: compiler optimization
#
# The same source is built once per set of compiler flags. Every run plays the video once
# from the start to the same time mark (LAB5_END_SECONDS in video_driver.hpp, 18 s = 1080
# frames), times the grayscale + Sobel calls of every frame, and reports the median.
# Five runs, about 40 min total on the Pi 5. Results go to $(LAB5_OUT)/:
#     Part 1: current implementation, -O0 and -O3 without vectorization
#     Part 3: current implementation, -O3
#     Part 4: current implementation, -O3 -march=native
#     Part 5: Lab 2 baseline, -O3 (the current -O3 row reuses the Part 3 run)
# lab5_part1 must run first: its -O0 run writes the reference captures the others compare to.
#==========================================================================================

LAB5_BASE_FLAGS := -std=c++17 -g -Wall -Wextra $(shell pkg-config --cflags opencv4)

LAB5_FLAGS_O0        := -O0
LAB5_FLAGS_O3_novec  := -O3 -fno-tree-loop-vectorize -fno-tree-slp-vectorize
LAB5_FLAGS_O3        := -O3
LAB5_FLAGS_O3_native := -O3 -march=native

LAB5_BUILDS := O0 O3_novec O3 O3_native
LAB5_BINS := $(addprefix $(TARGET)_,$(LAB5_BUILDS))

# resolution reported in $(LAB5_OUT)/lab5_summary.md
LAB5_SUMMARY_RES ?= 1920x1080

# where the Lab 5 run outputs, captures, and assembly listings go
LAB5_OUT ?= output2

lab5: lab5_part1 lab5_part2 lab5_part3 lab5_part4 lab5_part5 lab5_summary

lab5_part1: $(TARGET)_O0 $(TARGET)_O3_novec
	@mkdir -p $(LAB5_OUT)/captures
	./$(TARGET)_O0 lab5 $(VIDEO) current | tee $(LAB5_OUT)/part1_O0.txt
	./$(TARGET)_O3_novec lab5 $(VIDEO) current | tee $(LAB5_OUT)/part1_O3_novec.txt

# assembly of the pipelines (where the grayscale / Sobel loops live) for every build
lab5_part2: $(addprefix $(LAB5_OUT)/asm/memory_pipelines_,$(addsuffix .s,$(LAB5_BUILDS)))

lab5_part3: $(TARGET)_O3
	@mkdir -p $(LAB5_OUT)/captures
	./$(TARGET)_O3 lab5 $(VIDEO) current | tee $(LAB5_OUT)/part3_O3.txt

lab5_part4: $(TARGET)_O3_native
	@mkdir -p $(LAB5_OUT)/captures
	./$(TARGET)_O3_native lab5 $(VIDEO) current | tee $(LAB5_OUT)/part4_O3_native.txt

lab5_part5: $(TARGET)_O3
	@mkdir -p $(LAB5_OUT)/captures
	./$(TARGET)_O3 lab5 $(VIDEO) lab2 | tee $(LAB5_OUT)/part5_lab2_O3.txt

lab5_summary:
	awk -v res=$(LAB5_SUMMARY_RES) \
	    -v cpu="$$(lscpu | sed -n 's/^Model name: *//p' | head -1)" \
	    -v compiler="$$($(CXX) --version | head -1)" \
	    -v dir=$(LAB5_OUT) -f lab5_summary.awk \
	    $(LAB5_OUT)/part1_O0.txt $(LAB5_OUT)/part1_O3_novec.txt $(LAB5_OUT)/part3_O3.txt \
	    $(LAB5_OUT)/part4_O3_native.txt $(LAB5_OUT)/part5_lab2_O3.txt > $(LAB5_OUT)/lab5_summary.md
	cat $(LAB5_OUT)/lab5_summary.md

# BUILD_FLAGS / BUILD_TAG label each run's output and captures with its build
$(LAB5_BINS): $(TARGET)_%: $(SOURCES) $(HEADERS)
	$(CXX) $(LAB5_BASE_FLAGS) $(LAB5_FLAGS_$*) -DBUILD_FLAGS='"$(LAB5_FLAGS_$*)"' \
	    -DBUILD_TAG='"$*"' -DCAPTURE_DIR_PATH='"$(LAB5_OUT)/captures"' $(SOURCES) -o $@ $(LDLIBS)

# -g0 and no unwind tables keep the listings readable
$(LAB5_OUT)/asm/memory_pipelines_%.s: memory_pipelines.cpp $(HEADERS)
	@mkdir -p $(LAB5_OUT)/asm
	$(CXX) $(LAB5_BASE_FLAGS) $(LAB5_FLAGS_$*) -g0 -fno-asynchronous-unwind-tables \
	    -S memory_pipelines.cpp -o $@

clean:
	rm -f $(TARGET) $(QUICK_TARGET) $(LAB5_BINS)
