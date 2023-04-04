@echo off

REM clean stuff then do a final QuakeC recompile
cd src_maps
call clean.bat
cd ..
call dawn.bat 1

REM *******************************************************
REM *           SET THE NAME OF YOUR PAK BELOW            *
REM *******************************************************



set pakname=pak0



REM *******************************************************
REM *                 COMPILE THE PAK                     *
REM *******************************************************




if exist %pakname%.pak del %pakname%.pak

REM Make the PAK0
qpakman gfx maps progs sound textures gfx.wad csprogs.dat progs.dat quake.rc -o .\%pakname%.pak




REM *******************************************************
REM *           SET THE NAME OF YOUR ZIP BELOW            *
REM *******************************************************



set zipname=Dawn
if exist %zipname%.zip del %zipname%.zip



REM *******************************************************
REM *                 COMPILE THE ZIP                     *
REM *******************************************************


if not exist pak0.pak goto error

if exist dawn rmdir /Q/S dawn
md dawn
if exist pak0.pak copy pak0.pak dawn\pak0.pak
if exist Dawn_README.txt copy Dawn_README.txt dawn\Dawn_README.txt

REM copy sources
if exist ./src_qc xcopy src_qc dawn\src\qc /I /EXCLUDE:xsrc.txt
if exist ./src_csqc xcopy src_csqc dawn\src\csqc /I /EXCLUDE:xsrc.txt
if exist ./src_maps xcopy src_maps dawn\src\maps /I /EXCLUDE:xsrc.txt
if exist ./src_sprites xcopy src_maps dawn\src\sprites /I /EXCLUDE:xsrc.txt
if exist ./src_wads xcopy src_wads dawn\src\wads /I /EXCLUDE:xsrc.txt

if exist ./docs xcopy docs dawn\src\docs /I /s

REM Package the entire mod
7z a -r -ssw -tzip .\%zipname%.zip dawn/*.*

if exist dawn rmdir /Q/S dawn
if exist pak0.pak del pak0.pak

goto noerror

:error
echo pak0.pak not found!
pause

:noerror
