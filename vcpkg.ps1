param( $action, $port_name, $features )

if ( $action -eq "install" ) {
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --overlay-ports=./ports "$port_name[$features]" --editable
}