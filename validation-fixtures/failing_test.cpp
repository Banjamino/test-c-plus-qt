// FIXTURE: trips CTest. Use to replace a test body on a throwaway branch.
// Asserts a value the implementation does NOT produce, so the test fails.
#include <iostream>
#include "app/calculator.hpp"

int main() {
    const app::Calculator calc;
    if (calc.add(2, 2) == 5) {          // deliberately wrong expectation
        std::cout << "PASS\n";
        return 0;
    }
    std::cerr << "FAIL: add(2,2) != 5 (expected failure fixture)\n";
    return 1;                            // non-zero => CTest marks failed
}
