@echo off
setlocal
set ADB=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe
set DEVICE=10DE410M8C003S7
cd /d "D:\Kuliah\!Semester 5\Pemrograman Mobile\244107020211-mobile-course\07-week-7-clean-architecture"
if not exist screenshots mkdir screenshots

if not exist "%ADB%" (
  echo adb tidak ditemukan di: %ADB%
  echo Cari lokasinya dengan: where adb
  pause
  exit /b 1
)
"%ADB%" devices
echo.

call :shot after_notes_list "Layar daftar catatan"
call :shot after_notes_badge_dirty "Tambah catatan sampai badge 'belum sync' muncul"
call :shot after_notes_synced "Tekan sync sampai badge hilang"
call :shot after_note_detail "Buka detail catatan"
call :shot after_posts_online "Halaman posts saat online"
call :shot after_posts_force_offline "Posts dengan force offline ON"

echo.
echo Selesai. Isi folder screenshots:
dir screenshots
pause
exit /b 0

:shot
echo.
echo ==== %~2
echo Atur layar di HP, lalu tekan tombol apa saja di sini...
pause >nul
"%ADB%" -s %DEVICE% exec-out screencap -p > "screenshots\%~1.png"
exit /b
