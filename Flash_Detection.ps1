$ErrorActionPreference = "Stop"
$activex_is_installed = $false
If ((Test-Path $env:windir\System32\Macromed\Flash\Flash32*.ocx) -eq $true)
{
    $activex_is_installed = $true
    $activex_32_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\Flash32*.ocx -ErrorAction Stop
    $activex_32_bit_version = ((Get-Item $activex_32_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\System32\Macromed\Flash\Flash64*.ocx) -eq $true)
{
    $activex_is_installed = $true
    $activex_64_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\Flash64*.ocx -ErrorAction Stop
    $activex_64_bit_version = ((Get-Item $activex_64_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\SysWow64\Macromed\Flash\Flash*.ocx) -eq $true)
{
    $activex_is_installed = $true
    $activex_64_bit_in_32_bit_mode_file = Get-ChildItem $env:windir\SysWow64\Macromed\Flash\Flash*.ocx -ErrorAction Stop
    $activex_64_bit_in_32_bit_mode_version = ((Get-Item $activex_64_bit_in_32_bit_mode_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}

$plugin_is_installed = $false
If ((Test-Path $env:windir\System32\Macromed\Flash\NPSWF32*.dll) -eq $true)
{
    $plugin_is_installed = $true
    $plugin_32_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\NPSWF32*.dll -ErrorAction Stop
    $plugin_32_bit_version = ((Get-Item $plugin_32_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\System32\Macromed\Flash\NPSWF64*.dll) -eq $true)
{
    $plugin_is_installed = $true
    $plugin_64_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\NPSWF64*.dll -ErrorAction Stop
    $plugin_64_bit_version = ((Get-Item $plugin_64_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\SysWow64\Macromed\Flash\NPSWF*.dll) -eq $true)
{
    $plugin_is_installed = $true
    $plugin_64_bit_in_32_bit_mode_file = Get-ChildItem $env:windir\SysWow64\Macromed\Flash\NPSWF*.dll -ErrorAction Stop
    $plugin_64_bit_in_32_bit_mode_version = ((Get-Item $plugin_64_bit_in_32_bit_mode_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}

$pepper_is_installed = $false
If ((Test-Path $env:windir\System32\Macromed\Flash\pepflashplayer32*.dll) -eq $true)
{
    $pepper_is_installed = $true
    $pepper_32_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\pepflashplayer32*.dll -ErrorAction Stop
    $pepper_32_bit_version = ((Get-Item $pepper_32_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\System32\Macromed\Flash\pepflashplayer64*.dll) -eq $true)
{
    $pepper_is_installed = $true
    $pepper_64_bit_file = Get-ChildItem $env:windir\System32\Macromed\Flash\pepflashplayer64*.dll -ErrorAction Stop
    $pepper_64_bit_version = ((Get-Item $pepper_64_bit_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}
If ((Test-Path $env:windir\SysWow64\Macromed\Flash\pepflashplayer*.dll) -eq $true)
{
    $pepper_is_installed = $true
    $pepper_64_bit_in_32_bit_mode_file = Get-ChildItem $env:windir\SysWow64\Macromed\Flash\pepflashplayer*.dll -ErrorAction Stop
    $pepper_64_bit_in_32_bit_mode_version = ((Get-Item $pepper_64_bit_in_32_bit_mode_file | Select-Object -ExpandProperty VersionInfo).ProductVersion).replace(",",".")
}

If (($activex_is_installed) -or ($plugin_is_installed) -or ($pepper_is_installed))
{
    Write-Host "Installed"
}