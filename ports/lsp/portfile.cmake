if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/source/CMakeLists.txt")
    set( SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/source")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO leon-bckl/lsp-framework
        REF ${VERSION}
        SHA512 3c4cdce6c65d38e23b7bc524d1abf3ffcbc1af02a642365d948a39f4573abcffa6635caabd47f6aa2155c1796e81137bcc5a81b2229f2147a865ecb94fbf53ab
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
