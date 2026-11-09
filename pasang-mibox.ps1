# Pasang Glass TV (versi Mi Box 3: jadwal sholat + mode hemat) sebagai Home.
# Aman: Glass TV diuji jalan dulu SEBELUM launcher bawaan dimatikan. Kalau ada yang gagal,
# skrip langsung mengembalikan launcher bawaan.
# Launcher bawaan hanya DIMATIKAN (pm disable-user), tidak dihapus. Kembalikan dengan restore-mibox.ps1.
# Pakai:  powershell -ExecutionPolicy Bypass -File pasang-mibox.ps1 [-TvHost 192.168.1.5]
param([string]$TvHost = '192.168.1.5')
$ErrorActionPreference = 'Stop'

$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$apk = "$PSScriptRoot\glass-tv\launcher\app\build\outputs\apk\release\app-release.apk"
$dev = "$($TvHost):5555"
$stock = 'com.google.android.tvlauncher'
$me = 'com.gathin.tvhome'
function Tv([string]$cmd) { & $adb -s $dev shell $cmd }

function Healthy {
    Start-Sleep 4; $a = (Tv "pidof $me"); Start-Sleep 3; $b = (Tv "pidof $me")
    $focus = (Tv 'dumpsys window | grep -m1 mCurrentFocus')
    return ($a -and $a -eq $b -and "$focus" -like "*$me*")
}
function Undo([string]$why) {
    Write-Host "GAGAL: $why. Mengembalikan launcher bawaan..."
    Tv "pm enable --user 0 $stock" | Out-Null
    Tv "cmd package set-home-activity --user 0 $stock/.MainActivity" | Out-Null
    Tv "pm uninstall $me" | Out-Null
    Tv 'input keyevent KEYCODE_HOME' | Out-Null
    throw "Dibatalkan, Mi Box kembali ke launcher bawaan. ($why)"
}

if (-not (Test-Path $apk)) { throw "APK belum di-build: $apk" }
& $adb connect $dev | Out-Null
if ((& $adb -s $dev get-state 2>$null) -ne 'device') { throw "Mi Box di $TvHost tidak terhubung." }

Write-Host '1/4 Memasang APK...'
& $adb -s $dev install -r $apk
if ($LASTEXITCODE -ne 0) { throw 'Pemasangan APK gagal. Tidak ada yang diubah.' }

Write-Host '2/4 Menjalankan Glass TV untuk diuji...'
Tv "am start -n $me/.MainActivity" | Out-Null
if (-not (Healthy)) { Undo 'Glass TV tidak tampil atau terus restart' }

Write-Host '3/4 Menjadikan Glass TV sebagai Home (launcher bawaan dimatikan, tidak dihapus)...'
Tv "cmd package set-home-activity --user 0 $me/.MainActivity" | Out-Null
Tv "pm disable-user --user 0 $stock" | Out-Null
Tv 'input keyevent KEYCODE_HOME' | Out-Null
$homeAct = "$(Tv 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME' | Select-Object -Last 1)".Trim()
if ($homeAct -notlike "$me/*" -or -not (Healthy)) { Undo "Home mengarah ke '$homeAct'" }

Write-Host '4/4 Screensaver: jam + jadwal sholat...'
Tv "settings put secure screensaver_components $me/.ClockDream" | Out-Null

Write-Host "Selesai. Home sekarang: $homeAct"
Write-Host 'Tekan tombol Home di remote untuk melihatnya.'
