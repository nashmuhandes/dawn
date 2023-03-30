@echo off

echo.

set dontrun=%1

if exist progs.dat del progs.dat
if exist progs.lno del progs.lno

cd src_qc
fteqcc64 -src %cd%

cd ..
if not exist progs.dat goto error
del progs.lno

if defined dontrun goto done

cd ..
ironwail -game dawn +map start
goto done

:error:
@echo Compile errors in QuakeC

:done:
