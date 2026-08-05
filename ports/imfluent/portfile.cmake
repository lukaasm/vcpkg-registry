set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../sources/${PORT}/")
cmake_path(NORMAL_PATH SOURCE_PATH)

if (NOT IS_DIRECTORY ${SOURCE_PATH})
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO lukaasm/ImFluent
        REF fe7cf3ef784afc81aed55f24f39fcaa15cdf96cb
        SHA512 1b9d471fc79b8ae4f542f22144553ff123ccaa7d3d3c292f874c11185a8688b7a5eb19a89e69890c02429c25316401dbdc41fad51531412f974f5a986e8367e1
        HEAD_REF main
    )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ImFluent)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
