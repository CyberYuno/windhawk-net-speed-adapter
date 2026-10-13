param(
    [Parameter(Mandatory = $true)]
    [string]$WindhawkPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$storage = Get-Content -LiteralPath (Join-Path $WindhawkPath 'windhawk.ini')
$engineRelative = (($storage | Where-Object { $_ -match '^EnginePath=' }) -split '=', 2)[1]
$compilerRelative = (($storage | Where-Object { $_ -match '^CompilerPath=' }) -split '=', 2)[1]
$compilerRoot = Join-Path $WindhawkPath $compilerRelative
$engineRoot = Join-Path $WindhawkPath $engineRelative
$source = Join-Path $repoRoot 'net-speed-taskbar-adapter.wh.cpp'
$versionLine = Get-Content -LiteralPath $source | Where-Object { $_ -match '^// @version\s+' } | Select-Object -First 1
$version = ($versionLine -replace '^// @version\s+', '').Trim()
$outputDir = Join-Path $repoRoot 'build'
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
$output = Join-Path $outputDir "local@net-speed-taskbar-adapter_$version.dll"
$compileArgs = @(
    '-std=c++23', '-O2', '-shared', '-DUNICODE', '-D_UNICODE',
    '-DWINVER=0x0A00', '-D_WIN32_WINNT=0x0A00', '-D_WIN32_IE=0x0A00',
    '-DNTDDI_VERSION=0x0A000008', '-D__USE_MINGW_ANSI_STDIO=0', '-DWH_MOD',
    '-DWH_MOD_ID=L"local@net-speed-taskbar-adapter"',
    ('-DWH_MOD_VERSION=L"' + $version + '"'),
    (Join-Path $engineRoot '64\windhawk.lib'), $source,
    '-include', 'windhawk_api.h', '-target', 'x86_64-w64-mingw32',
    '-Wl,--export-all-symbols', '-o', $output,
    '-lgdiplus', '-liphlpapi', '-lgdi32', '-lshell32', '-DWIN32_LEAN_AND_MEAN'
)

Push-Location $compilerRoot
try {
    & (Join-Path $compilerRoot 'bin\clang++.exe') @compileArgs
    $compileExit = $LASTEXITCODE
    if ($compileExit -ne 0) { throw "Compiler exited with code $compileExit" }
} finally {
    Pop-Location
}
Write-Output "Built $output"
