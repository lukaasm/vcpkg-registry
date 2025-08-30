param( $action, $port_name, $features, $extra )

if ( $action -eq "install" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name --triplet=x64-windows
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name --triplet=x64-windows-static-md

    & "$Env:VCPKG_ROOT\vcpkg.exe" install --overlay-ports=./ports "$port_name[$features]" --triplet=x64-windows $extra

    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name --triplet=x64-windows
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --overlay-ports=./ports "$port_name[$features]" --triplet=x64-windows-static-md $extra
}

if ( $action -eq "remove" ) {
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name --triplet=x64-windows
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --overlay-ports=./ports $port_name --triplet=x64-windows-static-md
}

if ( $action -eq "update" ) {
    & "$Env:VCPKG_ROOT\vcpkg.exe" format-manifest "ports/nri/vcpkg.json"

    git add ports/$port_name
    git commit -m "- ${port_name}: update port"

    & "$Env:VCPKG_ROOT\vcpkg.exe" x-add-version --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions $port_name

    git add versions
    git commit -m "- ${port_name}: update version"
}