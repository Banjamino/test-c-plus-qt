## app — C++ skeletons

Minimal, buildable C++17 skeleton for the CortiSci application, set up for
PR-based development with build / unit-test / static-analysis / coverage checks.

## Decisions baked in
- **C++17**, no compiler extensions, standard required.
- **MSVC** target toolchain (CMake preset `msvc-debug`); also builds with GCC/Clang.
- **CMake + Ninja** build; `compile_commands.json` exported for analysis tools.
- **Warnings-as-errors** on (SOP-011 §5.4: no warnings in production code).
- **CTest** unit tests, passing from the first commit.

### MISRA C++:2023 — deliberately NOT enforced yet
MISRA is **not required** by the SOPs or IEC 62304 (the term appears in neither).
This skeleton uses a documented, free-enforceable coding standard instead
(C++ Core Guidelines + CERT via `.clang-tidy`). If a MISRA commitment is later
confirmed, add a MISRA-capable tool (Axivion / PVS-Studio / commercial
SonarQube) as the `sast` job in `.github/workflows/ci.yml` and in
`cmake/StaticAnalysis.cmake` — those are the single places to wire it in.
Until then nothing here depends on MISRA.

## Layout
```
CMakeLists.txt              # top-level build
CMakePresets.json           # msvc-debug, ci-linux presets
cmake/
  CompilerWarnings.cmake    # MSVC + GCC/Clang warning flags
  StaticAnalysis.cmake      # clang-tidy / cppcheck / coverage toggles
  Qt.cmake                  # optional Qt UI (APP_ENABLE_QT) for Clazy/qmllint
include/app/calculator.hpp  # example unit (replace with real code)
src/calculator.cpp
src/main.cpp
src/ui/main_window.{hpp,cpp}# minimal Qt widget (signal/slot → Clazy input)
qml/Main.qml                # clean QML (→ qmllint input, should PASS)
tests/
  CMakeLists.txt            # dependency-free harness OR GoogleTest (APP_USE_GTEST)
  test_calculator.cpp       # zero-dependency tests (default)
  test_calculator_gtest.cpp # GoogleTest variant
validation-fixtures/        # INTENTIONALLY BROKEN — prove each gate BLOCKS
  README.md                 # how to use the fixtures
  format_violation.cpp      # trips clang-format
  lint_violation.cpp        # trips clang-tidy / cppcheck
  warning_violation.cpp     # trips warnings-as-errors (build)
  failing_test.cpp          # trips CTest
  Broken.qml                # trips qmllint
scripts/validate-gates.sh   # local dry-run of the fixture checks
.clang-format               # formatting gate
.clang-tidy                 # static-analysis rules (Core Guidelines + CERT)
.github/workflows/ci.yml    # format, build-test (MSVC), qmllint, static-analysis, coverage
```

## Validating the pipeline BEFORE real development
This repo doubles as a **gate-validation harness**. The clean code passes every
gate; the files in `validation-fixtures/` each break exactly one gate, so you
can prove the pipeline *guards* — not just that it runs.

Procedure (per `validation-fixtures/README.md`):
1. Confirm the clean baseline is green on `develop`.
2. For each fixture: throwaway branch → copy fixture where the gate scans →
   open PR → **confirm the PR is blocked** by that gate → delete the branch.
3. If any fixture merges cleanly, that gate is misconfigured — fix before
   real development.

Quick local check (subset, tools permitting):
```
./scripts/validate-gates.sh
```


## Build & test
```
# MSVC (Windows)
cmake --preset msvc-debug
cmake --build --preset msvc-debug
ctest --preset msvc-debug

# GCC/Clang (Linux/local)
cmake -S . -B build -G Ninja
cmake --build build
ctest --test-dir build --output-on-failure
```

## Options
| Option | Default | Purpose |
|--------|---------|---------|
| `APP_WARNINGS_AS_ERRORS` | ON | Fail build on any warning |
| `APP_ENABLE_CLANG_TIDY` | OFF | Run clang-tidy in build (CI turns on) |
| `APP_ENABLE_CPPCHECK` | OFF | Run cppcheck in build (CI turns on) |
| `APP_ENABLE_COVERAGE` | OFF | gcov instrumentation (non-MSVC) |
| `APP_USE_GTEST` | OFF | Use GoogleTest instead of built-in harness |
| `APP_BUILD_TESTS` | ON | Build the test target |

## Open items (decide before release)
- **Safety class (A/B/C)** — sets the coverage gate (`--fail-under-line` in CI).
- **Coverage tool for MSVC** — OpenCppCoverage (gcov path is wired for Linux only).
- **SAST tool** — only needed if a MISRA/commercial commitment is confirmed.
- **Test framework** — flip `APP_USE_GTEST` on once dependencies are managed.
