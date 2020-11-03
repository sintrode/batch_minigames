::------------------------------------------------------------------------------
:: NAME
::     WASD
::
:: USAGE
::     wasd.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     Press the corresponding button when the X appears
::         W - up
::         A - left
::         S - down
::         D - right
::     People who use DVORAK or other nonstandard layouts will have to adjust
::     the code accordingly. Replace WASD with KHJL if you want to practice vim
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion
mode con cols=15 lines=10

set "score=0"
:go
cls
for /L %%A in (1,1,4) do set "button[%%A]= "
set /a hit_me=%random%%%4+1
set "button[%hit_me%]=X"
echo(      [%button[1]%]
echo( [%button[2]%]  [%button[3]%]  [%button[4]%]
choice /C:WASDQ /T 1 /D Q /N >nul

if not "%hit_me%"=="%errorlevel%" goto :fail
set /a score+=1
goto :go

:fail
mode con cols=80 lines=23
echo Final score: %score%
exit /b