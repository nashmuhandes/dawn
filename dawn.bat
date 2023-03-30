@echo off

echo.

set dontrun=%1

REM Convert all TGAs to GFX LMPs
cd src_gfx
for %%v in (*.tga) do (
	tga2lmp %%v
	if exist %%~nv.lmp xcopy %%~nv.lmp ..\gfx\%%~nv.lmp* /Y
	if exist %%~nv.lmp del %%~nv.lmp
)
cd ..

REM delete old progs
if exist progs.dat del progs.dat
if exist progs.lno del progs.lno

REM Compile QuakeC
cd src_qc
fteqcc64 -src %cd%

REM Cleanup
cd ..
if not exist progs.dat goto error
del progs.lno

REM Don't run the game if specified
if defined dontrun goto done

cd ..
ironwail -game dawn +map start
goto done

:error:
@echo Compile errors in QuakeC

:done:
