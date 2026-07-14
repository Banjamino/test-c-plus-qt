#include <iostream>

#include "app/calculator.hpp"

int main() {
    const app::Calculator calc;
    std::cout << "app skeleton: 2 + 3 = " << calc.add(2, 3) << '\n';
    return 0;
}
