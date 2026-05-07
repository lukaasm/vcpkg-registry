#set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../sources/${PORT}/")
#cmake_path(NORMAL_PATH SOURCE_PATH)

if (NOT IS_DIRECTORY ${SOURCE_PATH})
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO soufianekhiat/ImAnim
        REF main
        SHA512 03651fce2e3f14f5b4b40ae95417ef7c99208cd374f7c958530753c7c3d7243427ee6c0cacc6fdb7cdc5b191d6525986a7bb52393c34a7939fa2e8561dc5c057
        HEAD_REF main
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
