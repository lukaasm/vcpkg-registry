param( $action, $port_name, $features, $extra )

if ( $action -eq "update") {
    $port_source = "ports/${port_name}"

    if ( Test-Path "${port_source}/source" ) {
        git -C ${port_source}/source diff > $port_source/fix_port.patch
    }

    & "$Env:VCPKG_ROOT\vcpkg.exe" format-manifest "./ports/${port_name}/vcpkg.json"
}

if ( $action -eq "install" -or $action -eq "install-static" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$PSScriptRoot/ports $port_name --triplet=x64-windows-static-md --recurse $extra
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --classic --overlay-ports=$PSScriptRoot/ports "$port_name[$features]" --triplet=x64-windows-static-md $extra
}

if ($action -eq "install" -or $action -eq "install-shared" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$PSScriptRoot/ports $port_name --triplet=x64-windows --recurse $extra
    & "$Env:VCPKG_ROOT\vcpkg.exe" install --classic --overlay-ports=$PSScriptRoot/ports "$port_name[$features]" --triplet=x64-windows  $extra
}

if ( $action -eq "remove" ) {
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$PSScriptRoot/ports $port_name --triplet=x64-windows --recurse $extra
    & "$Env:VCPKG_ROOT\vcpkg.exe" remove --classic --overlay-ports=$PSScriptRoot/ports $port_name --triplet=x64-windows-static-md --recurse $extra
}

if ( $action -eq "commit" ) {
    git -C . add ports/$port_name
    git -C . commit -m "- ${port_name}: update port $features"

    & "$Env:VCPKG_ROOT\vcpkg.exe" x-add-version --classic --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions $port_name --overwrite-version

    git -C . add versions
    git -C . commit -m "- ${port_name}: update versions $features"
}