@echo off

c:
cd %USERPROFILE%
cd .android

::��ֹ 0x9BB50x2D95 ��������һ���vid����adb��ʶ������
set bbk_need_stop_adb_2D95=0
set bbk_need_stop_adb_9BB5=0
set bbk_need_stop_adb_18D1=0
set bbk_need_stop_adb_0E8D=0

for /f %%i in (adb_usb.ini) do (if "%%i"=="0x2D95" set bbk_need_stop_adb_2D95=1)
for /f %%i in (adb_usb.ini) do (if "%%i"=="0x2d95" set bbk_need_stop_adb_2D95=1)

for /f %%i in (adb_usb.ini) do (if "%%i"=="0x9BB5" set bbk_need_stop_adb_9BB5=1)
for /f %%i in (adb_usb.ini) do (if "%%i"=="0x9bb5" set bbk_need_stop_adb_9BB5=1)

for /f %%i in (adb_usb.ini) do (if "%%i"=="0x18D1" set bbk_need_stop_adb_18D1=1)
for /f %%i in (adb_usb.ini) do (if "%%i"=="0x18d1" set bbk_need_stop_adb_18D1=1)

for /f %%i in (adb_usb.ini) do (if "%%i"=="0x0E8D" set bbk_need_stop_adb_0E8D=1)
for /f %%i in (adb_usb.ini) do (if "%%i"=="0x0e8d" set bbk_need_stop_adb_0E8D=1)

set /a bbk_need_stop_adb=%bbk_need_stop_adb_2D95%+%bbk_need_stop_adb_9BB5%+%bbk_need_stop_adb_18D1%+%bbk_need_stop_adb_0E8D%
echo %bbk_need_stop_adb%
if %bbk_need_stop_adb% EQU 4 goto end

adb kill-server

::����д���ļ�,��β���ӻ��з��ţ���ֹ���д���������vid
for /f %%i in (adb_usb.ini) do (echo %%i>>adb_usb.ini.bak)
del /q adb_usb.ini
ren adb_usb.ini.bak adb_usb.ini

::����id
if %bbk_need_stop_adb_2D95% equ 0 echo 0x2D95>>adb_usb.ini
if %bbk_need_stop_adb_9BB5% equ 0 echo 0x9BB5>>adb_usb.ini
if %bbk_need_stop_adb_18D1% equ 0 echo 0x18D1>>adb_usb.ini
if %bbk_need_stop_adb_0E8D% equ 0 echo 0x0E8D>>adb_usb.ini

adb start-server

:end
echo end success