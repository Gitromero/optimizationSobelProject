CXX := gcc
CXXFLAGS := -std=c++17 -g -O0 -Wall -Wextra $(shell pkg-config --cflags opencv4)
LDLIBS := $(shell pkg-config --libs opencv4) -lstdc++ -lm

TARGET := video_driver
SOURCES := video_driver.cpp optimizations.cpp

.PHONY: all clean run

all: $(TARGET)

run: $(TARGET)
	./$(TARGET)

$(TARGET): $(SOURCES)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $@ $(LDLIBS)

clean:
	rm -f $(TARGET)
