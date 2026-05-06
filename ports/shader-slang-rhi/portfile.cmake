vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

set(SOURCE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../sources/${PORT}/" )
cmake_path(NORMAL_PATH SOURCE_PATH )

if (NOT IS_DIRECTORY ${SOURCE_PATH})
    vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO shader-slang/slang-rhi
        REF 155a262f972368fae9a90a89d7ea9f81c83dc5a7
        SHA512 7a5a70a9435700659f68851ad7285ef695f2be72794a86175d821feedee220349122a7004e96d29db0fe076c3bd16c40199150744a90056f022a34bd8903fa47
        HEAD_REF main
        PATCHES
            #fix_port.patch
    )
endif()

message("${PORT_NAME} - ${SOURCE_PATH}")

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
