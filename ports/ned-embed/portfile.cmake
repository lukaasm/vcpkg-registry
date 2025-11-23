if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/source/CMakeLists.txt")
    set( SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/source")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO lukaasm/imgui-ned-embed
        REF adc6da70d3a1f9f7f5f18b807f297e446b63a028
        SHA512 adc6da70d3a1f9f7f5f18b807f297e446b63a028
        HEAD_REF cleanup
    )
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIBS )

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DUSE_BUNDLED_ZLIB=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME "ned")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
