get_filename_component(OZZ_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)

macro(_ozz_add_library target libname)
    if(NOT TARGET ozz::${target})
        add_library(ozz::${target} STATIC IMPORTED)
        set_target_properties(ozz::${target} PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${OZZ_IMPORT_PREFIX}/include"
            IMPORTED_LOCATION "${OZZ_IMPORT_PREFIX}/lib/${libname}.lib"
            IMPORTED_LOCATION_RELEASE "${OZZ_IMPORT_PREFIX}/lib/${libname}.lib")
        set_property(TARGET ozz::${target} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
        if(EXISTS "${OZZ_IMPORT_PREFIX}/debug/lib/${libname}.lib")
            set_property(TARGET ozz::${target} APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
            set_target_properties(ozz::${target} PROPERTIES
                IMPORTED_LOCATION_DEBUG "${OZZ_IMPORT_PREFIX}/debug/lib/${libname}.lib")
        endif()
    endif()
endmacro()

_ozz_add_library(base ozz_base)
_ozz_add_library(animation ozz_animation)
_ozz_add_library(animation_offline ozz_animation_offline)

set_property(TARGET ozz::animation APPEND PROPERTY INTERFACE_LINK_LIBRARIES ozz::base)
set_property(TARGET ozz::animation_offline APPEND PROPERTY INTERFACE_LINK_LIBRARIES ozz::animation)
