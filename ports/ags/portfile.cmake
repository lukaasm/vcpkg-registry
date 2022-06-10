set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO GPUOpen-LibrariesAndSDKs/AGS_SDK
    REF v${VERSION}
    SHA512 365a1b284cf407795bd53dcd33ae1d1bfc968b5a1c6a6d67bad7beba2ab57b222491898837700d26314349fbc890bd003a69dc4d8777b939efe3283ef6e5657d
    HEAD_REF main
)

file(GLOB incs
	"${SOURCE_PATH}/ags_lib/inc/*.h"
	"${SOURCE_PATH}/ags_lib/hlsl/*"
)

file(INSTALL ${incs} DESTINATION "${CURRENT_PACKAGES_DIR}/include")

if ( VCPKG_LIBRARY_LINKAGE STREQUAL "static" )
  set (AGS_CRT_LINKAGE "MD")
  if (VCPKG_CRT_LINKAGE STREQUAL "static")
    set(AGS_CRT_LINKAGE "MT")
  endif()

  file(GLOB libs
    "${SOURCE_PATH}/ags_lib/lib/*${VCPKG_TARGET_ARCHITECTURE}_2022_${AGS_CRT_LINKAGE}.lib"
  )

  file(INSTALL ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
  file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
else()
  file(GLOB dlls "${SOURCE_PATH}/ags_lib/lib/*_${VCPKG_TARGET_ARCHITECTURE}.dll")
  file(INSTALL ${dlls} DESTINATION "${CURRENT_PACKAGES_DIR}/bin")

  file(INSTALL ${libs} DESTINATION "${CURRENT_PACKAGES_DIR}/lib/amd_ags_${VCPKG_TARGET_ARCHITECTURE}.lib")
endif()


vcpkg_install_copyright( FILE_LIST "${SOURCE_PATH}/LICENSE.txt")