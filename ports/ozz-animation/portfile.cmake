vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO guillaumeblanc/ozz-animation
    REF "${VERSION}"
    SHA512 a7acfeb22850b19f9763e431b59131606db4068a40cf855cda3bd087984b776753bde7847481552c43e4ab8c5ba32886211f41a0f694130e2ed0ce73aa192f46
    HEAD_REF master
)

set(OZZ_MSVC_RT_DLL OFF)
if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
    set(OZZ_MSVC_RT_DLL ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dozz_build_tools=OFF
        -Dozz_build_fbx=OFF
        -Dozz_build_gltf=OFF
        -Dozz_build_data=OFF
        -Dozz_build_samples=OFF
        -Dozz_build_howtos=OFF
        -Dozz_build_tests=OFF
        -Dozz_build_simd_ref=OFF
        -Dozz_build_postfix=OFF
        "-Dozz_build_msvc_rt_dll=${OZZ_MSVC_RT_DLL}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/ozz-animation-config.cmake"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/doc")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
