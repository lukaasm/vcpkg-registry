cmake_minimum_required(VERSION 3.8)
project(imanim)

set(CMAKE_CXX_STANDARD 11)

find_package(imgui CONFIG REQUIRED)
add_library(${PROJECT_NAME} "")

target_include_directories(
	${PROJECT_NAME}
	PUBLIC
	   	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
		$<INSTALL_INTERFACE:include>
	PRIVATE
		${IMGUI_INCLUDE_DIRS}
)

target_link_libraries(${PROJECT_NAME} PUBLIC imgui::imgui)
target_sources(
    ${PROJECT_NAME}
    PRIVATE
        im_anim.cpp
        im_anim_usecase.cpp
        im_anim_doc.cpp
        im_anim_demo.cpp
)

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
