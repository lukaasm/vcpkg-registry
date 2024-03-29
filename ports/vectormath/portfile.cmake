vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO glampert/vectormath
    REF ee960fad0a4bbbf0ee2e7d03fc749c49ebeefaef
    SHA512 670a051650edac589d04294d93efa4dbb3613efbe6366caae0600d37ddd0d65a3f9fe2a750350153a15737ae7e6c743fdc670a1c00c30174ef827dd051611fa9
    HEAD_REF master
)

file(INSTALL "${SOURCE_PATH}/" DESTINATION "${CURRENT_PACKAGES_DIR}/include/${PORT}" FILES_MATCHING PATTERN *.hpp)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/${PORT}/docs")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
