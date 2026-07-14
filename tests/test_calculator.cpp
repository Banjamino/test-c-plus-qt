// test_calculator.cpp
// Zero-dependency unit test harness so the skeleton builds and tests pass with
// no external packages (e.g. on a clean MSVC CI runner). Selects which case to
// run via argv[1] so each maps to a distinct CTest test. Returns non-zero on
// failure; CTest interprets that as a failed test.
//
// Once a test framework is adopted (APP_USE_GTEST=ON), prefer
// test_calculator_gtest.cpp and retire this harness.

#include <cstring>
#include <iostream>

#include "app/calculator.hpp"

namespace {

int test_add() {
    const app::Calculator calc;
    if (calc.add(2, 3) != 5) {
        std::cerr << "FAIL: add(2,3) expected 5, got " << calc.add(2, 3) << '\n';
        return 1;
    }
    if (calc.add(-4, 4) != 0) {
        std::cerr << "FAIL: add(-4,4) expected 0\n";
        return 1;
    }
    std::cout << "PASS: add\n";
    return 0;
}

int test_subtract() {
    const app::Calculator calc;
    if (calc.subtract(10, 3) != 7) {
        std::cerr << "FAIL: subtract(10,3) expected 7\n";
        return 1;
    }
    std::cout << "PASS: subtract\n";
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "usage: calculator_tests <add|subtract>\n";
        return 2;
    }
    if (std::strcmp(argv[1], "add") == 0) {
        return test_add();
    }
    if (std::strcmp(argv[1], "subtract") == 0) {
        return test_subtract();
    }
    std::cerr << "unknown test case: " << argv[1] << '\n';
    return 2;
}
