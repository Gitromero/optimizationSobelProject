CXX := gcc
CXXFLAGS := -std=c++17 -g -O0 -Wall -Wextra $(shell pkg-config --cflags opencv4)
LDLIBS := $(shell pkg-config --libs opencv4) -lstdc++ -lm

TARGET := video_driver
SOURCES := video_driver.cpp memory_pipelines.cpp compare.cpp lab3_reference.cpp \
           traversal.cpp cache_info.cpp
HEADERS := video_driver.hpp memory_pipelines.hpp compare.hpp lab3_reference.hpp \
           traversal.hpp cache_info.hpp

# 4K source video (same one used in Labs 2 and 3)
VIDEO ?= ../bbb_sunflower_2160p_60fps_normal.mp4

.PHONY: all clean run part1 part2 part3 part4 part5

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

$(TARGET): $(SOURCES) $(HEADERS)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $@ $(LDLIBS)

clean:
	rm -f $(TARGET)
