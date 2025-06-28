vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NVIDIA-RTX/ShaderMake
    REF de47d8677843ee2fd1a231b94970e71818252a62
    SHA512 333fd658652af79f02271539529ad832849d914a3abaa0f626bbf018c9923c61bfca72a1f1c5f5d09095685fa3f64bc61f71fad3eaec45af34553fa932ce955b
    HEAD_REF main
    PATCHES
        install_targets.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
vcpkg_copy_tools(TOOL_NAMES ShaderMake AUTO_CLEAN)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
