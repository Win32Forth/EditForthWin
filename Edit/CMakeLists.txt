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

# build.bat passes arm64. build-x64.bat passes x64. The name is
# editforthwinarm64.exe or editforthwinx64.exe.
set(EDITFORTH_ARCH "" CACHE STRING "arm64 or x64 suffix for the editor executable")
if(NOT EDITFORTH_ARCH)
    if(CMAKE_CXX_COMPILER_ARCHITECTURE_ID MATCHES "ARM64")
        set(EDITFORTH_ARCH "arm64")
    else()
        set(EDITFORTH_ARCH "x64")
    endif()
endif()
message(STATUS "EditForthWin editor executable: editforthwin${EDITFORTH_ARCH}.exe")

set_target_properties(editforthwin PROPERTIES
    OUTPUT_NAME "editforthwin${EDITFORTH_ARCH}"
    WIN32_EXECUTABLE TRUE
)
