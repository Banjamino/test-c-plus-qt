# StaticAnalysis.cmake
# Wires optional static-analysis tools into the build. Each is opt-in via a
# cache option so the base build stays portable. CI turns on the ones that
# are installed and configured.
#
# NOTE ON MISRA: none of these free tools provide certified MISRA C++:2023
# coverage. MISRA is NOT required by the SOPs or IEC 62304 (it does not
# appear in either). If a MISRA commitment is later confirmed, add a
# MISRA-capable tool (Axivion / PVS-Studio / commercial SonarQube) as an
# additional analysis step here — this file is the single place to do it.

function(app_enable_static_analysis target)
    # --- clang-tidy ---------------------------------------------------------
    if(APP_ENABLE_CLANG_TIDY)
        find_program(CLANG_TIDY_EXE NAMES clang-tidy)
        if(CLANG_TIDY_EXE)
            # .clang-tidy at repo root defines the enabled checks.
            set_target_properties(${target} PROPERTIES
                CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
            message(STATUS "clang-tidy enabled: ${CLANG_TIDY_EXE}")
        else()
            message(WARNING "APP_ENABLE_CLANG_TIDY=ON but clang-tidy not found")
        endif()
    endif()

    # --- cppcheck -----------------------------------------------------------
    if(APP_ENABLE_CPPCHECK)
        find_program(CPPCHECK_EXE NAMES cppcheck)
        if(CPPCHECK_EXE)
            set_target_properties(${target} PROPERTIES
                CXX_CPPCHECK "${CPPCHECK_EXE};--enable=warning,style,performance,portability;--inline-suppr;--error-exitcode=1;--std=c++17")
            message(STATUS "cppcheck enabled: ${CPPCHECK_EXE}")
        else()
            message(WARNING "APP_ENABLE_CPPCHECK=ON but cppcheck not found")
        endif()
    endif()

    # --- coverage (GCC/Clang only; MSVC uses OpenCppCoverage externally) ----
    if(APP_ENABLE_COVERAGE AND NOT MSVC)
        # PUBLIC so consumers (app, tests) inherit both the instrumentation
        # and the gcov runtime link requirement.
        target_compile_options(${target} PUBLIC --coverage -O0 -g)
        target_link_options(${target} PUBLIC --coverage)
        message(STATUS "coverage instrumentation enabled for ${target}")
    endif()
endfunction()
