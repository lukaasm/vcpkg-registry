param( $action, $port_name, $features, $extra )

$vcpkg = Join-Path $Env:VCPKG_ROOT "vcpkg.exe"
$portsOverlay = Join-Path $PSScriptRoot "ports"
$templatesDir = Join-Path $PSScriptRoot "templates"

function Get-RegistryTemplate([string] $Name) {
    $path = Join-Path $templatesDir $Name
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Template not found: $path"
    }
    return [System.IO.File]::ReadAllText($path, [System.Text.UTF8Encoding]::new($false))
}

function Escape-JsonTemplateValue([string] $Value) {
    if ($null -eq $Value) { return '' }
    return $Value.Replace('\', '\\').Replace('"', '\"').Replace("`r", '\r').Replace("`n", '\n').Replace("`t", '\t')
}

function Get-GitHubRepoFromUrl([string] $url) {
    if ([string]::IsNullOrWhiteSpace($url)) { return $null }
    $u = $url.Trim().TrimEnd('.git')
    if ($u -match 'github\.com[:/]([^/]+)/([^/]+)') {
        return "$($matches[1])/$($matches[2])"
    }
    return $null
}

function ConvertTo-DisplayRepoUrl([string] $url) {
    if ([string]::IsNullOrWhiteSpace($url)) { return $url }
    $u = $url.Trim()
    if ($u -match '^git@github\.com:(.+)\.git$') {
        return "https://github.com/$($matches[1])"
    }
    if ($u -match '^git@github\.com:(.+)$') {
        return "https://github.com/$($matches[1])"
    }
    return $u
}

if ( $action -eq "update") {
    $portDir = Join-Path (Join-Path $PSScriptRoot "ports") $port_name
    $sourceDir = Join-Path (Join-Path $PSScriptRoot "sources") $port_name

    if ( Test-Path -LiteralPath $sourceDir ) {
        git -C $sourceDir diff > (Join-Path $portDir "fix_port.patch")
    }

    & $vcpkg format-manifest (Join-Path $portDir "vcpkg.json")
}

if ( $action -eq "install" -or $action -eq "install-static" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & $vcpkg remove --classic --overlay-ports=$portsOverlay $port_name --triplet=x64-windows-static --recurse $extra
    & $vcpkg install --classic --overlay-ports=$portsOverlay "$port_name[$features]" --triplet=x64-windows-static $extra
}

if ($action -eq "install" -or $action -eq "install-shared" ) {
    if ( [string]::IsNullOrEmpty($features) ) {
        $features = "core"
    }
    & $vcpkg remove --classic --overlay-ports=$portsOverlay $port_name --triplet=x64-windows --recurse $extra
    & $vcpkg install --classic --overlay-ports=$portsOverlay "$port_name[$features]" --triplet=x64-windows $extra
}

if ( $action -eq "remove" ) {
    & $vcpkg remove --classic --overlay-ports=$portsOverlay $port_name --triplet=x64-windows --recurse $extra
    & $vcpkg remove --classic --overlay-ports=$portsOverlay $port_name --triplet=x64-windows-static --recurse $extra
}

if ( $action -eq "create" ) {
    if ([string]::IsNullOrWhiteSpace($port_name)) {
        Write-Error "create requires a port name."
        exit 1
    }
    if ([string]::IsNullOrWhiteSpace($Env:VCPKG_ROOT)) {
        Write-Error "VCPKG_ROOT is not set."
        exit 1
    }

    $destPort = Join-Path (Join-Path $PSScriptRoot "ports") $port_name
    if (Test-Path -LiteralPath $destPort) {
        Write-Error "Port already exists in this registry: $destPort"
        exit 1
    }

    $builtinPort = Join-Path (Join-Path $Env:VCPKG_ROOT "ports") $port_name
    if (Test-Path -LiteralPath $builtinPort) {
        Copy-Item -LiteralPath $builtinPort -Destination $destPort -Recurse
        & $vcpkg format-manifest (Join-Path $destPort "vcpkg.json")
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        exit 0
    }

    $repoUrl = Read-Host "Repository URL (clone URL or https page)"
    if ([string]::IsNullOrWhiteSpace($repoUrl)) {
        Write-Error "Repository URL is required when the port is not in VCPKG_ROOT."
        exit 1
    }

    $repoUrl = $repoUrl.Trim()
    $homepage = ConvertTo-DisplayRepoUrl $repoUrl
    $githubRepo = Get-GitHubRepoFromUrl $repoUrl

    $sourceDir = Join-Path (Join-Path $PSScriptRoot "sources") $port_name
    if (Test-Path -LiteralPath $sourceDir) {
        Write-Error "Source directory already exists (submodule or folder): $sourceDir"
        exit 1
    }

    $gitWorkTree = git -C $PSScriptRoot rev-parse --is-inside-work-tree 2>$null
    if ($gitWorkTree -ne "true") {
        Write-Error "Registry root is not a git repository: $PSScriptRoot"
        exit 1
    }

    $submodulePath = "sources/$port_name"
    git -C $PSScriptRoot submodule add $repoUrl $submodulePath
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    $null = New-Item -ItemType Directory -Path $destPort -Force

    $description = "${port_name} (scaffold - update metadata and portfile)."
    $manifest = (Get-RegistryTemplate "vcpkg.json.in").
        Replace('__PORT_NAME__', (Escape-JsonTemplateValue $port_name)).
        Replace('__DESCRIPTION__', (Escape-JsonTemplateValue $description)).
        Replace('__HOMEPAGE__', (Escape-JsonTemplateValue $homepage))
    Set-Content -LiteralPath (Join-Path $destPort "vcpkg.json") -Value $manifest.TrimEnd() -Encoding utf8

    if ($githubRepo) {
        $portfile = (Get-RegistryTemplate "portfile.cmake.in").Replace('__GITHUB_REPO__', $githubRepo)
    } else {
        $escaped = $repoUrl -replace '\\', '\\\\' -replace '"', '\"'
        $portfile = (Get-RegistryTemplate "portfile.git.cmake.in").Replace('__GIT_URL__', $escaped)
    }

    Set-Content -LiteralPath (Join-Path $destPort "portfile.cmake") -Value $portfile.TrimEnd() -Encoding utf8

    & $vcpkg format-manifest (Join-Path $destPort "vcpkg.json")
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if ( $action -eq "rebuild" ) {
    $root = $PSScriptRoot
    $versionsDir = Join-Path $root "versions"

    if (-not (Test-Path -LiteralPath $portsOverlay)) {
        Write-Error "Ports directory not found: $portsOverlay"
        exit 1
    }

    if (Test-Path -LiteralPath $versionsDir) {
        Get-ChildItem -LiteralPath $versionsDir -Force | Remove-Item -Recurse -Force
    } else {
        New-Item -ItemType Directory -Path $versionsDir -Force | Out-Null
    }

    $baselineJson = (Get-RegistryTemplate "baseline.json.in").TrimEnd()
    Set-Content -LiteralPath (Join-Path $versionsDir "baseline.json") -Value $baselineJson -Encoding utf8

    Push-Location $root
    try {
        & $vcpkg x-add-version --all --classic `
            "--x-builtin-ports-root=$portsOverlay" `
            "--x-builtin-registry-versions-dir=$versionsDir" `
            $extra
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    } finally {
        Pop-Location
    }

    git -C $PSScriptRoot add versions
    git -C $PSScriptRoot diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git -C $PSScriptRoot commit -m "- registry: rebuild versions database"
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
}

if ( $action -eq "commit" ) {
    $portDir = Join-Path (Join-Path $PSScriptRoot "ports") $port_name
    $versionsDir = Join-Path $PSScriptRoot "versions"
    & $vcpkg format-manifest (Join-Path $portDir "vcpkg.json")

    git -C $PSScriptRoot add "ports/$port_name"
    git -C $PSScriptRoot commit -m "- ${port_name}: update port $features"

    & $vcpkg x-add-version --classic `
        "--x-builtin-ports-root=$portsOverlay" `
        "--x-builtin-registry-versions-dir=$versionsDir" `
        $port_name --overwrite-version

    git -C $PSScriptRoot add versions
    git -C $PSScriptRoot commit -m "- ${port_name}: update port $features" --amend
}