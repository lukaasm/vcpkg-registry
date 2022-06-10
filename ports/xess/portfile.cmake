set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO intel/xess
    REF v${VERSION}
    SHA512 6129abf9a271c366e8d04f2676ec8f39858cd8e1530b0178911a0c5e1c616db56bc6c577aa3cec2d63f23310cedb658f5e7b463469bb467482bb40af59ed155a
    HEAD_REF main
)

file(GLOB libs
	"${SOURCE_PATH}/lib/*.lib"
)

file(INSTALL ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")

file(GLOB incs
	"${SOURCE_PATH}/inc/*/*.h"
)

file(INSTALL ${incs} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

if(VCPKG_TARGET_IS_WINDOWS)
  file(GLOB dlls "${SOURCE_PATH}/bin/*.dll")
  file(INSTALL ${dlls} DESTINATION "${CURRENT_PACKAGES_DIR}/bin")
endif()

vcpkg_install_copyright( FILE_LIST "${SOURCE_PATH}/LICENSE.txt" "${SOURCE_PATH}/third-party-programs.txt")