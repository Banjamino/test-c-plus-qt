# tests/CMakeLists.txt
#
# Unit tests must exist and pass from the first PR (SOP-011 §5.5; and per the
# project CI/CD plan, CTest gates every PR). To keep the skeleton buildable
# with zero external dependencies, the default test is a self-contained
# executable that returns non-zero on failure — CTest treats that as fail.
#
# A GoogleTest-based path is provided behind APP_USE_GTEST for when you adopt
# a framework (recommended once dependencies are managed via vcpkg/FetchContent).

option(APP_USE_GTEST "Use GoogleTest for unit tests instead of the built-in harness" OFF)

if(APP_USE_GTEST)
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        v1.14.0)
    # For Windows/MSVC: link the gtest runtime the same way as the rest.
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    add_executable(calculator_tests test_calculator_gtest.cpp)
    target_link_libraries(calculator_tests PRIVATE app_lib GTest::gtest_main)
    app_set_warnings(calculator_tests)

    include(GoogleTest)
    gtest_discover_tests(calculator_tests)
else()
    add_executable(calculator_tests test_calculator.cpp)
    target_link_libraries(calculator_tests PRIVATE app_lib)
    app_set_warnings(calculator_tests)

    add_test(NAME calculator_add      COMMAND calculator_tests add)
    add_test(NAME calculator_subtract COMMAND calculator_tests subtract)
endif()
