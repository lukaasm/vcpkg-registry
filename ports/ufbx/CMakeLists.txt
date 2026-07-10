cmake_minimum_required(VERSION 3.8)
project(ufbx C)

add_library(ufbx STATIC ufbx.c)

target_include_directories(ufbx PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>)

install(FILES ufbx.h DESTINATION include)

install(TARGETS ufbx
    EXPORT ufbx-target
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin)

install(EXPORT ufbx-target
    NAMESPACE ufbx::
    FILE ufbx-config.cmake
    DESTINATION share/ufbx)
