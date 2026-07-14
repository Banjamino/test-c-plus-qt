cmake_minimum_required(VERSION 3.21)

# ---------------------------------------------------------------------------
# Project
# ---------------------------------------------------------------------------
project(app
    VERSION 0.1.0
    DESCRIPTION "CortiSci application skeleton"
    LANGUAGES CXX)

# ---------------------------------------------------------------------------
# Language standard: C++17 (SDP decision). Enforced, no compiler extensions.
# ---------------------------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Export compile_commands.json so clang-tidy / cppcheck / SAST tools can
# consume the exact build configuration (required for accurate C++ analysis).
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------------------------
# Options (toggles) — analysis tooling is opt-in so the base build stays
# portable. CI enables the ones that are configured; MISRA stays OFF until
# a MISRA-capable tool is selected and the commitment is confirmed.
# ---------------------------------------------------------------------------
option(APP_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" ON)
option(APP_ENABLE_CLANG_TIDY  "Run clang-tidy during build"        OFF)
option(APP_ENABLE_CPPCHECK    "Run cppcheck during build"          OFF)
option(APP_ENABLE_COVERAGE    "Instrument for coverage (non-MSVC)" OFF)
option(APP_BUILD_TESTS        "Build unit tests"                   ON)

include(cmake/CompilerWarnings.cmake)
include(cmake/StaticAnalysis.cmake)
include(cmake/Qt.cmake)

# ---------------------------------------------------------------------------
# Library target (the code under test) + application entry point.
# Keeping logic in a library makes it unit-testable; main() just calls in.
# ---------------------------------------------------------------------------
add_library(app_lib
    src/calculator.cpp)
target_include_directories(app_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_features(app_lib PUBLIC cxx_std_17)
app_set_warnings(app_lib)
app_enable_static_analysis(app_lib)

add_executable(app src/main.cpp)
target_link_libraries(app PRIVATE app_lib)
app_set_warnings(app)

# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------
if(APP_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# ---------------------------------------------------------------------------
# Optional Qt UI sample (gives Clazy/qmllint real input). No-op unless
# APP_ENABLE_QT=ON and a Qt SDK is found.
# ---------------------------------------------------------------------------
app_add_qt_ui()
