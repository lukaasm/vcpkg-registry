vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../sources/${PORT}/")
cmake_path(NORMAL_PATH SOURCE_PATH)

if (NOT IS_DIRECTORY ${SOURCE_PATH})
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO goossens/ImGuiColorTextEdit
        REF 5fa8326e618b7da8210727ee7ad09661e1baa9dd
        SHA512 9e802ea1f3438e75db5c48379b4fa6262fbc949a69f3c2788a12ff8a6b1849305a521e778c2deee4bd2c2b66db7689d0049d5a9eea7c812e84fb4a9803e6ff41
        HEAD_REF future
        PATCHES
            fix_port.patch
    )
endif()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
