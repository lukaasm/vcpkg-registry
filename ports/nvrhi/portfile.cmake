vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nvidia-rtx/nvrhi
    REF dbb422dd3ec189168995efab3aa63eae7eb00d83
    SHA512 f6f98f8151f848ac1f092c9be2f4723acda8187872de4b0164b4779931b39e1db8ad3abf8501f4019c2140a296872957b91bc1cb39e5d299634f76e8e39818dd
    HEAD_REF main
    PATCHES
        find_vulcan.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        vulkan  NVRHI_WITH_VULKAN
        dx11    NVRHI_WITH_DX11
        dx12    NVRHI_WITH_DX12
        rtxmu   NVRHI_WITH_RTXMU
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS ${FEATURE_OPTIONS}
        -DNVRHI_INSTALL=ON
        -DNVRHI_INSTALL_EXPORTS=ON
        -DNVRHI_WITH_VALIDATION=ON
        -DNVRHI_BUILD_SHARED=${BUILD_SHARED}
        -DNVRHI_WITH_AFTERMATH=OFF
        -DNVRHI_WITH_NVAPI=OFF
        ${WINDOWS_STATIC_RUNTIME}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/nvrhi)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")