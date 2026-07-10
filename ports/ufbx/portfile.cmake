vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ufbx/ufbx
    REF "v${VERSION}"
    SHA512 d489b94dcb2d565433a2636bdb8c64bdcec589f7162974096dc276fef29d5c19b35d11d122539ab96298e89778fe6579dacd778cd8b8b64259aaae81daf30b2c
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME ufbx)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
