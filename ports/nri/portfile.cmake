vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NVIDIA-RTX/NRI
    REF v${VERSION}
    SHA512 41875c5a60509cbba41dc1b21a15941ac2ea8a170b71de5e55d561f32438db05a4687f90e2e125220748a63425fcb4bf9dce392582ff59470221142c7e6dbe58
    HEAD_REF main
    PATCHES fix_vendor_dependencies.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        none        NRI_ENABLE_NONE_SUPPORT
        vulkan      NRI_ENABLE_VK_SUPPORT
        d3d11       NRI_ENABLE_D3D11_SUPPORT
        d3d12       NRI_ENABLE_D3D12_SUPPORT
        validation  NRI_ENABLE_VALIDATION_SUPPORT
        imgui       NRI_ENABLE_IMGUI_EXTENSION
)

if ("imgui" IN_LIST FEATURES)
    set(TOOL_SHADERMAKE ${CURRENT_HOST_INSTALLED_DIR}/tools/shadermake/ShaderMake${VCPKG_HOST_EXECUTABLE_SUFFIX})
    find_program(SHADERMAKE_DXC_VK_PATH "$ENV{VULKAN_SDK}/Bin/dxc")
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" NRI_STATIC_LIBRARY)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSHADERMAKE_PATH=${TOOL_SHADERMAKE}
        -DSHADERMAKE_DXC_VK_PATH=${SHADERMAKE_DXC_VK_PATH}
        -DNRI_ENABLE_NVTX_SUPPORT=OFF
        -DNRI_ENABLE_DEBUG_NAMES_AND_ANNOTATIONS=OFF
        -DNRI_ENABLE_VALIDATION_SUPPORT=OFF
        -DNRI_ENABLE_D3D_EXTENSIONS=OFF
        -DNRI_ENABLE_AGILITY_SDK_SUPPORT=OFF
        -DNRI_STATIC_LIBRARY=${NRI_STATIC_LIBRARY}
    MAYBE_UNUSED_VARIABLES
        SHADERMAKE_PATH
        SHADERMAKE_FXC_PATH
        SHADERMAKE_DXC_PATH
        SHADERMAKE_DXC_VK_PATH
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME "nri")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
