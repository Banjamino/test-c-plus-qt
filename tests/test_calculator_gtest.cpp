// test_calculator_gtest.cpp
// GoogleTest-based unit tests (used when APP_USE_GTEST=ON). Preferred once a
// dependency manager (vcpkg / FetchContent) is in place. Each TEST maps to a
// discovered CTest case via gtest_discover_tests().

#include <gtest/gtest.h>

#include "app/calculator.hpp"

TEST(CalculatorTest, AddsPositiveNumbers) {
    const app::Calculator calc;
    EXPECT_EQ(calc.add(2, 3), 5);
}

TEST(CalculatorTest, AddsToZero) {
    const app::Calculator calc;
    EXPECT_EQ(calc.add(-4, 4), 0);
}

TEST(CalculatorTest, Subtracts) {
    const app::Calculator calc;
    EXPECT_EQ(calc.subtract(10, 3), 7);
}
