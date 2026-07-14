// FIXTURE: trips clang-tidy / cppcheck. Copy into src/ on a throwaway branch.
// - C-style cast (cppcoreguidelines / MISRA-adjacent)
// - raw owning `new` without delete (memory leak: cppcheck + clang-tidy)
// - magic number
#include "app/calculator.hpp"

namespace app {

int leaky() {
    int* p = new int(42);          // leak: never deleted
    double d = (double)*p;          // C-style cast
    return (int)(d * 3.14159);      // C-style cast + magic number
}

}  // namespace app
