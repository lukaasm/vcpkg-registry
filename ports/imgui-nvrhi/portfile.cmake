vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lukaasm/imgui-nvrhi-binding
    REF 22171acf0f1aec0989d52b5d8474466a061eb379
    SHA512 f0fb5e70ee47e5ca433aec8494e9a499bd3408540da9079a21d751a1cecc80cde4b840626764467ee4a555243c8d5189de8a5753b6cfea3aca967ffcb1f1e8d2
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/ImguiNVRHI" PACKAGE_NAME "ImguiNVRHI" )

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
