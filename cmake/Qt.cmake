# Qt.cmake
# Optional Qt integration. Kept behind APP_ENABLE_QT so the core build stays
# buildable without a Qt SDK (e.g. for quick CI checks or environments without
# Qt). CI that runs Clazy and qmllint enables this so those gates have real
# Qt/QML input to analyze.

option(APP_ENABLE_QT "Build the Qt UI sample (needed for Clazy/qmllint gates)" OFF)

function(app_add_qt_ui)
    if(NOT APP_ENABLE_QT)
        return()
    endif()

    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    find_package(Qt6 COMPONENTS Core Gui Widgets Qml Quick QUIET)
    if(NOT Qt6_FOUND)
        find_package(Qt5 COMPONENTS Core Gui Widgets Qml Quick QUIET)
    endif()

    if(NOT (Qt6_FOUND OR Qt5_FOUND))
        message(WARNING "APP_ENABLE_QT=ON but no Qt SDK found; skipping Qt UI target")
        return()
    endif()

    add_executable(app_ui
        src/ui/main_window.cpp
        src/ui/main_window.hpp)
    target_include_directories(app_ui PRIVATE ${CMAKE_SOURCE_DIR}/include ${CMAKE_SOURCE_DIR}/src)
    target_link_libraries(app_ui PRIVATE app_lib)

    if(Qt6_FOUND)
        target_link_libraries(app_ui PRIVATE Qt6::Core Qt6::Gui Qt6::Widgets Qt6::Qml Qt6::Quick)
    else()
        target_link_libraries(app_ui PRIVATE Qt5::Core Qt5::Gui Qt5::Widgets Qt5::Qml Qt5::Quick)
    endif()

    app_set_warnings(app_ui)
    message(STATUS "Qt UI sample enabled")
endfunction()
