vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lukaasm/imgui-nvrhi-binding
    REF f1d307e208975ba54c3f0eaef1384c0aa1df8c2e
    SHA512 3d3a0ce874a67ce5362c10d84c1137d27740ceaa074a7353ed8543d2feb88d9568172df21620d082476c46fbae6b4a0234d9f2306adcb6ef27545da25a0e2065
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/ImguiNVRHI" PACKAGE_NAME "ImguiNVRHI" )

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
