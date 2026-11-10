# Glass TV untuk Mi Box 3 — Jadwal Sholat, Jam Flip & Adzan

Ganti Home Xiaomi Mi Box 3 (MDZ-16-AB, Android 9) yang penuh iklan dengan launcher kaca yang ringan, sekaligus jadikan TV papan jadwal sholat:

- Screensaver jam flip besar yang terbaca dari jauh.
- Hitung mundur ke waktu sholat berikutnya.
- Nada pengumuman 5 menit sebelum adzan, lalu suara adzan.

**Langsung pakai:** APK sudah jadi, termasuk suara adzan. Cukup jalankan satu skrip dari PC Windows. Tidak perlu root dan tidak perlu build, sekitar 10 menit, dan bisa dikembalikan seperti semula dengan satu skrip.

Diuji pada **Mi Box 3** (`MIBOX3`, Android 9, Amlogic S905X, RAM 2 GB). Versi untuk TV Sony ada di [Sony-BRAVIA-4K-GB](https://github.com/pututjr/Sony-BRAVIA-4K-GB). Bisa juga dicoba di Android TV lain dengan Android 8 ke atas.

| Screensaver | Home |
| --- | --- |
| ![Screensaver](docs/screensaver.png) | ![Home](docs/home.png) |

| Pengingat 5 menit sebelum adzan |
| --- |
| ![Pengingat](docs/pengingat.png) |

## Fitur

- **Screensaver jadwal sholat**:
  - Kota, hari + pasaran Jawa (mis. *Selasa Legi*), dan tanggal Hijriyah.
  - Jam flip besar `HH:MM:SS` yang angkanya membalik tiap detik.
  - Kotak hitung mundur *MENUJU ISYA 01:10:17*, dan lima kartu waktu sholat dengan waktu berikutnya disorot emas.
  - Latar biru malam dengan siluet masjid. Isi layar bergeser sedikit tiap menit agar tidak burn-in.
- **Home bergaya kaca:** jam dan waktu sholat berikutnya di kiri atas, foto tempat dari Bing yang berganti tiap minggu, dan dock berisi YouTube, Netflix, Prime Video, dan MX Player.
- **Jadwal sholat** dihitung di TV tanpa internet, dengan kriteria Kemenag: Subuh 20°, Isya 18°, Ashar Syafi'i, ihtiyat +2 menit. Kota bisa diganti saat memasang.
- **Pengingat 5 menit sebelum adzan**:
  - Nada pengumuman ala stasiun disusul suara *"waktu sholat tiba"*.
  - Pil *"5 menit lagi Ashar · 14:35"* berkedip selama 30 detik di atas aplikasi apa pun (YouTube, Netflix, MX Player) dan juga di screensaver.
- **Adzan** (rekaman *Adzan Kurdi*) untuk Dzuhur, Ashar, Maghrib dan Isya. Subuh sengaja dilewati. Video yang sedang diputar dijeda, dan panel *"Waktu Ashar"* tampil. Tekan **OK** atau **Back** untuk menghentikan adzan.
- **Ringan untuk Mi Box 3:** gerakan dibuat lebih tenang, dan efek blur kaca dihitung di ⅓ ukuran layar. Saat screensaver tampil, pemakaian CPU sekitar 9% dan RAM sekitar 30 MB.
- **Aman:** Mi Box otomatis dicadangkan dulu. Launcher bawaan hanya dimatikan, tidak dihapus.

## Isi repo

| File | Fungsi |
| --- | --- |
| `apk/glass-tv-mibox.apk` | APK siap pakai: Glass TV + jadwal sholat + adzan (≈ 3 MB) |
| `pasang-mibox.ps1` | Memasang semuanya: unduh adb bila perlu, backup otomatis, pasang APK, atur kota, Home, screensaver, dan izin adzan |
| `backup-mibox.ps1` | Mencadangkan kondisi Mi Box (hanya membaca). Dipanggil otomatis oleh `pasang-mibox.ps1` |
| `restore-mibox.ps1` | Mengembalikan Mi Box ke kondisi saat backup |
| `glass-tv-mibox.patch` | Kode sumbernya, untuk yang ingin build sendiri (lihat bagian akhir) |

## Langkah 1 — Siapkan Mi Box

1. Buka **Settings → Device Preferences → About**.
2. Arahkan ke **Build**, lalu tekan OK di remote 7 kali sampai muncul *"You are now a developer"*.
3. Buka **Device Preferences → Developer options**, lalu nyalakan **USB debugging**. Kalau ada **Network debugging**, nyalakan juga.
4. Catat IP Mi Box di **Settings → Network & Internet →** nama Wi-Fi yang tersambung. Contoh: `192.168.1.5`.

Mi Box dan PC harus berada di jaringan yang sama.

## Langkah 2 — Unduh repo ini

Klik **Code → Download ZIP** di halaman GitHub ini, lalu ekstrak, misalnya ke `D:\Mibox-Glass-TV`. Bisa juga dengan Git:

```bash
git clone https://github.com/pututjr/Mibox-Glass-TV.git
```

## Langkah 3 — Pasang ke Mi Box

Buka **PowerShell**, lalu jalankan. Ganti IP dengan IP Mi Box Anda.

```powershell
cd D:\Mibox-Glass-TV
powershell -ExecutionPolicy Bypass -File pasang-mibox.ps1 -TvHost 192.168.1.5
```

Pada percobaan pertama, TV menampilkan **Allow USB debugging?** Centang **Always allow from this computer**, tekan OK, lalu jalankan perintahnya sekali lagi.

**Kota lain (default Malang):** tambahkan nama kota dan koordinatnya. Koordinat bisa diambil dari Google Maps dengan klik kanan pada kota.

```powershell
powershell -ExecutionPolicy Bypass -File pasang-mibox.ps1 -TvHost 192.168.1.5 -Kota Jakarta -Lat -6.2088 -Lng 106.8456
```

| Kota | `-Lat` | `-Lng` |
| --- | --- | --- |
| Jakarta | -6.2088 | 106.8456 |
| Surabaya | -7.2575 | 112.7521 |
| Bandung | -6.9175 | 107.6191 |
| Yogyakarta | -7.7956 | 110.3695 |
| Semarang | -6.9667 | 110.4167 |
| Medan | 3.5952 | 98.6722 |
| Makassar | -5.1477 | 119.4327 |

Skrip ini:

1. Mengunduh adb resmi dari Google bila belum ada di PC.
2. Membuat folder `backup-mibox-<tanggal>` sekali saja, sebelum ada yang diubah.
3. Memasang APK dan menyimpan lokasi kota.
4. Menjadikan Glass TV sebagai Home. Launcher bawaan dimatikan, tidak dihapus.
5. Memasang screensaver jadwal sholat (muncul setelah 5 menit).
6. Memberi izin *tampil di atas aplikasi lain* untuk pengingat adzan.

Kalau ada langkah yang gagal, launcher bawaan otomatis dikembalikan.

**Cek:** keluar `Selesai. Home sekarang: com.gathin.tvhome/.MainActivity` dan `Pengingat/adzan berikutnya: ...`. Kalau volume Mi Box terlalu kecil untuk adzan, skrip juga memberi peringatan.

**Tips:** tahan OK pada aplikasi, pilih **Move**, lalu geser untuk mengatur urutan. Screensaver bisa langsung dilihat lewat **Settings → Device Preferences → Screen saver → Start now**.

## Catatan

- **Volume adzan** mengikuti volume Mi Box (0–15, lewat HDMI) dan volume TV.
- Pengingat dan adzan hanya berjalan saat Mi Box dan TV menyala, termasuk saat screensaver tampil.
- Tanggal Hijriyah memakai kalender Umm al-Qura, jadi bisa selisih sehari dengan kalender Kemenag. Pasaran dan tanggal Hijriyah berganti pukul 00:00.
- **Sudah memasang versi lama dari repo ini?** Jalankan `pasang-mibox.ps1` lagi. Kalau muncul `INSTALL_FAILED_UPDATE_INCOMPATIBLE`, APK lama dibuat di PC lain. Hapus dulu dengan `adb uninstall com.gathin.tvhome`, lalu jalankan skripnya lagi.
- Setelah selesai, matikan **USB/Network debugging** bila jaringan dipakai banyak orang.

## Kembali ke semula

```powershell
cd D:\Mibox-Glass-TV\backup-mibox-<tanggal>
powershell -ExecutionPolicy Bypass -File restore-mibox.ps1 -TvHost 192.168.1.5
```

Skrip ini:

- Menghapus Glass TV, termasuk alarm adzannya.
- Menyalakan lagi aplikasi yang dimatikan.
- Memulihkan launcher, screensaver, dan waktu tunggu screensaver seperti saat backup.

Factory reset juga tetap bisa dipakai, karena tidak ada aplikasi sistem yang dihapus.

## Masalah umum

| Gejala | Solusi |
| --- | --- |
| `unauthorized` / `failed to authenticate` | Centang **Always allow** di TV, tekan OK, lalu ulangi perintah |
| `connection refused` / `offline` | Mi Box sedang standby atau IP berubah. Nyalakan, lalu cek USB debugging dan IP |
| `running scripts is disabled` | Jalankan lewat `powershell -ExecutionPolicy Bypass -File ...` seperti contoh di atas |
| Pengingat tidak muncul di atas aplikasi lain | Jalankan `pasang-mibox.ps1` sekali lagi |
| Adzan terlalu pelan | Naikkan volume Mi Box dan TV |
| Aplikasi tidak muncul di dock | Aplikasi itu tidak punya ikon TV. Atur lewat **Move**, atau ubah `dock_apps` dan build sendiri |
| Tanggal Hijriyah beda sehari | Build sendiri dengan `hijri_offset_days` = `-1` atau `1` (lihat bawah) |

## Build sendiri (opsional)

Hanya perlu kalau ingin mengubah isi, misalnya mengganti rekaman adzan, mengubah dock aplikasi, atau menggeser tanggal Hijriyah. Butuh Git, JDK 17, dan Android SDK, dengan unduhan sekitar 650 MB. JDK 21/25 bawaan Android Studio **tidak** bisa dipakai, karena Gradle 8.9 butuh JDK 17.

**a. Alat** (PowerShell). Lewati yang sudah ada:

```powershell
$ProgressPreference='SilentlyContinue'; $dl="$env:TEMP\androiddl"; $sdk="$env:LOCALAPPDATA\Android\Sdk"
New-Item -ItemType Directory -Force $dl,$sdk,"$sdk\cmdline-tools" | Out-Null
Invoke-WebRequest "https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse" -OutFile "$dl\jdk17.zip"
Invoke-WebRequest "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip" -OutFile "$dl\clt.zip"
Expand-Archive "$dl\jdk17.zip" "$env:LOCALAPPDATA\jdk-tmp" -Force
Move-Item (Get-ChildItem "$env:LOCALAPPDATA\jdk-tmp" -Directory)[0].FullName "$env:LOCALAPPDATA\jdk17"
Expand-Archive "$dl\clt.zip" "$sdk\clt-tmp" -Force
Move-Item "$sdk\clt-tmp\cmdline-tools" "$sdk\cmdline-tools\latest"
```

Lalu di **Git Bash** (perintah `yes` menyetujui lisensi Android SDK dari Google):

```bash
export JAVA_HOME="$LOCALAPPDATA/jdk17"; SDK="$LOCALAPPDATA/Android/Sdk"
yes | "$SDK/cmdline-tools/latest/bin/sdkmanager.bat" --sdk_root="$SDK" --licenses
```

**b. Kode, patch, dan build** (Git Bash, dari folder repo ini). Build pertama memakan 3–5 menit.

```bash
git clone -c core.longpaths=true https://github.com/cocombee/glass-tv.git
cd glass-tv && git checkout -q ce164b6 && git apply ../glass-tv-mibox.patch && echo "patch OK"
cd launcher
printf 'sdk.dir=%s\n' "$(cygpath -m "$LOCALAPPDATA/Android/Sdk")" > local.properties
export JAVA_HOME="$LOCALAPPDATA/jdk17"
./gradlew.bat testReleaseUnitTest assembleRelease -q --console=plain
```

Yang bisa diubah sebelum build:

- **Rekaman adzan:** `launcher/app/src/main/res/raw/adzan.mp3`
- **Nada pengingat:** `launcher/app/src/main/res/raw/pengumuman.ogg`
- **Kota default, dock aplikasi, dan `hijri_offset_days`:** `launcher/app/src/main/res/values/config.xml`

Setelah build, `pasang-mibox.ps1` otomatis memakai `glass-tv\launcher\app\build\outputs\apk\release\app-release.apk` bila file itu ada.

| Gejala build | Solusi |
| --- | --- |
| Pesan versi Java | Pastikan `JAVA_HOME` mengarah ke JDK 17 |
| `classes.dex ... being used by another process` | Antivirus sedang memindai file build. Tunggu beberapa detik lalu build lagi |
| `git apply` gagal | Pastikan sudah `git checkout ce164b6` |
| `Filename too long` saat clone | Pakai `-c core.longpaths=true` seperti di atas |

## Kredit dan lisensi

- Launcher: [Glass TV](https://github.com/cocombee/glass-tv) oleh cocombee, berdasarkan [Clean Your TV](https://github.com/Gathin23/cleanyourtv) oleh Gathin. Keduanya berlisensi MIT.
- Font Outfit berlisensi SIL OFL. Rumus posisi matahari mengikuti [PrayTimes.org](http://praytimes.org/), dengan parameter kriteria Kemenag RI.
- Tanggal Hijriyah memakai `android.icu.util.IslamicCalendar` (Umm al-Qura) bawaan Android. Pasaran Jawa memakai patokan 17 Agustus 1945 = Jumat Legi.
- Rekaman *Adzan Kurdi* disertakan agar bisa langsung dipakai dan disebarluaskan untuk dakwah.
- Foto latar Home adalah gambar harian Bing. Foto yang memuat orang dilewati otomatis.
- Patch, skrip, nada pengumuman, dan suara *"waktu sholat tiba"* berlisensi MIT, lihat [LICENSE](LICENSE).
