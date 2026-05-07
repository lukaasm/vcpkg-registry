cmake_minimum_required(VERSION 3.10)
project(imguicolortextedit)

set(CMAKE_CXX_STANDARD 17)

find_path(DTL_INCLUDE_DIRS "dtl/Diff.hpp")

find_package(imgui CONFIG REQUIRED)
add_library(${PROJECT_NAME} "")

target_include_directories(
	${PROJECT_NAME}
	PUBLIC
	   	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	PRIVATE
		${IMGUI_INCLUDE_DIRS}
)

target_link_libraries(${PROJECT_NAME} PUBLIC imgui::imgui)
target_sources(
    ${PROJECT_NAME}
    PRIVATE
        TextEditor.cpp
        TextDiff.cpp
)

target_include_directories( ${PROJECT_NAME} PRIVATE ${DTL_INCLUDE_DIRS})

install(FILES TextDiff.h TextEditor.h DESTINATION include )
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}-target
    ARCHIVE DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(
    EXPORT ${PROJECT_NAME}-target
    NAMESPACE ${PROJECT_NAME}::
    FILE ${PROJECT_NAME}-config.cmake
    DESTINATION share/${PROJECT_NAME}
)
