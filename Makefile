# Compiler
CXX = clang++

# Flags
CXXFLAGS = -Iinclude -Wall -Wextra -pedantic -O2 -pipe

# Packages
PKGS = libnotify
LDFLAGS = $(shell pkg-config --libs $(PKGS))

# Const
SRCS = $(wildcard src/*.cpp)
OBJS = $(patsubst src/%.cpp, build/%.o, $(SRCS))
HEADERS = $(wildcard include/*.h)
BUILD_DIR = build

TARGET = remcpp

all: $(BUILD_DIR) $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Linking
$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)

# Compiling object files
$(BUILD_DIR)/%.o: src/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Include
-include $(OBJS:.o=.d)

# Rules for deps
$(BUILD_DIR)/%.d: src/%.cpp
	$(CXX) $(CXXFLAGS) -M $< > $@

# Clang check
clang_check:
	find . -name "*.cpp" | xargs clang-format -style=Google -n
	find . -name "*.h" | xargs clang-format -style=Google -n

# Clang format
clang_format: clang_check
	find . -name "*.cpp" | xargs clang-format -style=Google -i
	find . -name "*.h" | xargs clang-format -style=Google -i

# Clean
clean:
	rm -rf $(BUILD_DIR) $(TARGET) ./remcpp

.PHONY: all clean clang_check clang_format

