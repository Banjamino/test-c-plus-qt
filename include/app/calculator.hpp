#ifndef APP_CALCULATOR_HPP
#define APP_CALCULATOR_HPP

namespace app {

/// Minimal example "software unit" so the build and unit-test wiring are real.
/// Replace with actual application units as development proceeds. Each such
/// unit should trace to a Ketryx requirement (REQ-ID) once it implements one.
class Calculator {
public:
    /// Returns the sum of two integers.
    [[nodiscard]] int add(int lhs, int rhs) const noexcept;

    /// Returns the difference (lhs - rhs).
    [[nodiscard]] int subtract(int lhs, int rhs) const noexcept;
};

}  // namespace app

#endif  // APP_CALCULATOR_HPP
