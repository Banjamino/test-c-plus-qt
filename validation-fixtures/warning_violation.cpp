// FIXTURE: trips warnings-as-errors (build fails). Copy into src/.
// - unused variable, implicit narrowing conversion, sign-conversion
#include "app/calculator.hpp"

namespace app {

int noisy(unsigned int u) {
    int unused;                 // unused variable (-Werror)
    double d = 3.9;
    int narrowed = d;           // implicit narrowing double->int
    return narrowed + u;        // signed/unsigned mix
}

}  // namespace app
