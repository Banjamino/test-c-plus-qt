# CompilerWarnings.cmake
# Central warning configuration. The SOP coding standard requires "no
# compiler/linter warnings in production code" (SOP-011 §5.4), so warnings
# are treated as errors by default.

function(app_set_warnings target)
    set(_msvc_warnings
        /W4          # high warning level
        /permissive- # strict standard conformance
        /w14640      # thread-unsafe static member init
        /w14826      # conversion is sign-extended
        /w14905 /w14906
        /wd4251)     # (example) silence a noisy DLL-interface warning if needed

    set(_gcc_clang_warnings
        -Wall -Wextra -Wpedantic
        -Wshadow -Wconversion -Wsign-conversion
        -Wnon-virtual-dtor -Wold-style-cast -Wcast-align
        -Wunused -Woverloaded-virtual -Wnull-dereference
        -Wdouble-promotion -Wformat=2)

    if(MSVC)
        target_compile_options(${target} PRIVATE ${_msvc_warnings})
        if(APP_WARNINGS_AS_ERRORS)
            target_compile_options(${target} PRIVATE /WX)
        endif()
    else()
        target_compile_options(${target} PRIVATE ${_gcc_clang_warnings})
        if(APP_WARNINGS_AS_ERRORS)
            target_compile_options(${target} PRIVATE -Werror)
        endif()
    endif()
endfunction()
