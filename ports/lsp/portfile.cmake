if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/source/CMakeLists.txt")
    set( SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/source")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO leon-bckl/lsp-framework
        REF ${VERSION}
        SHA512 6622512dd6defe07fc18c5d99ce6d33430b78c86194661fcc8cd3bebba59471b9e68c84423ba2bce3427f4d8fa131481ff153ef455bf2f67d009734ff58204e5
        HEAD_REF main
        PATCHES
            fix_port.patch
    )
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED_LIBS )

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
