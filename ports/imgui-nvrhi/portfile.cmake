vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lukaasm/imgui-nvrhi-binding
    REF 5cb376cb0376ea03641679b6b84ab375ac285d5a
    SHA512 134cc89ffc0e82c2b571a821d183ae36f9384c1f6a6fc14ae9c177d66d2932c2442514baf2d5b57c8aadafaaec51558a1940282aebc4055de743596ae137149d
    HEAD_REF main
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/ImguiNVRHI" PACKAGE_NAME "ImguiNVRHI" )

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
