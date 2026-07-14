#include "app/calculator.hpp"

namespace app {

int Calculator::add(int lhs, int rhs) const noexcept {
    return lhs + rhs;
}

int Calculator::subtract(int lhs, int rhs) const noexcept {
    return lhs - rhs;
}

}  // namespace app
