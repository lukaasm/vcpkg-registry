set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../sources/${PORT}/")
cmake_path(NORMAL_PATH SOURCE_PATH)

if (NOT IS_DIRECTORY ${SOURCE_PATH})
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO lukaasm/ImFluent
        REF 59d8ff0decd1f05538339dde6d55e0aaea28f583
        SHA512 a47d4579caddc3a28f1d58c951298448eb3b21522eabc0a643c0ea2c0949d87049af554e8a84963221b81fc55111221fddd98e660f72ce7af97d951b9098aaa8
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
