cmake_minimum_required(VERSION 3.21)
project(EditForthWinEditor LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets)
qt_standard_project_setup()

qt_add_executable(editforthwin WIN32
    src/main.cpp
    src/MainWindow.cpp
    src/CodeEdit.cpp
    src/DebugBar.cpp
    src/ForthConsole.cpp
    src/ForthPipe.cpp
)

target_link_libraries(editforthwin PRIVATE Qt6::Widgets)

set_target_properties(editforthwin PROPERTIES
    OUTPUT_NAME editforthwin
    WIN32_EXECUTABLE TRUE
)
