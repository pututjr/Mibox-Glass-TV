# Kembalikan Mi Box 3 ke kondisi saat backup dibuat.
# - Menghapus Glass TV (com.gathin.tvhome)
# - Menyalakan lagi semua aplikasi yang dimatikan setelah backup
# - Menjadikan launcher bawaan Google TV sebagai Home lagi
# - Mengembalikan screensaver bawaan (Backdrop)
# Pakai:  powershell -ExecutionPolicy Bypass -File restore-mibox.ps1 [-TvHost 192.168.1.5]
param([string]$TvHost = '192.168.1.5')

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$here = $PSScriptRoot
function Tv([string]$cmd) { & $adb -s "$($TvHost):5555" shell $cmd }

& $adb connect "$($TvHost):5555" | Out-Null
$state = & $adb -s "$($TvHost):5555" get-state 2>$null
if ($state -ne 'device') { throw "Mi Box di $TvHost tidak terhubung. Pastikan TV menyala dan USB debugging aktif." }

$wasDisabled = Get-Content "$here\packages-disabled.txt" | ForEach-Object { ($_ -replace '^package:', '').Trim() } | Where-Object { $_ }
$nowDisabled = Tv 'pm list packages -d' | ForEach-Object { ($_ -replace '^package:', '').Trim() } | Where-Object { $_ }

foreach ($p in $nowDisabled) {
    if ($wasDisabled -notcontains $p) {
        Write-Host "Menyalakan lagi: $p"
        Tv "pm enable --user 0 $p" | Out-Null
    }
}

Tv 'cmd package set-home-activity --user 0 com.google.android.tvlauncher/.MainActivity' | Out-Null
Tv 'settings put secure screensaver_components com.google.android.backdrop/.Backdrop' | Out-Null
Tv 'pm uninstall com.gathin.tvhome' | Out-Null
Tv 'input keyevent KEYCODE_HOME' | Out-Null

$homeAct = (Tv 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME' | Select-Object -Last 1).Trim()
Write-Host "Home sekarang: $homeAct"
if ($homeAct -like 'com.google.android.tvlauncher/*') { Write-Host 'Selesai: Mi Box kembali seperti semula.' }
else { Write-Host 'Perhatian: Home belum kembali ke launcher bawaan. Tekan Home di remote, lalu jalankan skrip ini sekali lagi.' }
