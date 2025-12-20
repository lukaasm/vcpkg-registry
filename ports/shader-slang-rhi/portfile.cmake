if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/source/CMakeLists.txt")
    set( SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/source")
else()
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO shader-slang/slang-rhi
        REF a51266ab01ca2cdb3f6a6ac90c9a8ebbf2fb59ba
        SHA512 9454cab5241a19236a72b472323a891a63267abb016818eeb64603e6b05a74888a828c06335905adf87915aa7de3324383e62b981b3c7f1cf82dfb2888adb6e8
        HEAD_REF main
        PATCHES
            fix_port.patch
    )
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        vulkan      SLANG_RHI_ENABLE_VULKAN
        d3d11       SLANG_RHI_ENABLE_D3D11
        d3d12       SLANG_RHI_ENABLE_D3D12
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SLANG_RHI_BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSLANG_RHI_BUILD_SHARED=${SLANG_RHI_BUILD_SHARED}
        -DSLANG_RHI_INSTALL=ON
        -DSLANG_RHI_BUILD_TESTS=OFF
        -DSLANG_RHI_BUILD_EXAMPLES=OFF
        -DSLANG_RHI_FETCH_SLANG=OFF
        ${FEATURE_OPTIONS}
        -DSLANG_RHI_ENABLE_CPU=ON
        -DSLANG_RHI_ENABLE_AGILITY_SDK=OFF
        -DSLANG_RHI_ENABLE_NVAPI=OFF
        -DSLANG_RHI_ENABLE_METAL=OFF
        -DSLANG_RHI_ENABLE_CUDA=OFF
        -DSLANG_RHI_ENABLE_OPTIX=OFF
        -DSLANG_RHI_ENABLE_WGPU=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME "slang-rhi")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
