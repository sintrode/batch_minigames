::------------------------------------------------------------------------------
:: NAME
::     High-Low
::
:: USAGE
::     hilo.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     The computer thinks of a random number between 1 and 100. The user then
::     guesses what the number is and the computer responds with whether the
::     guess was too high or too low.
::
::     If you play optimally, you only need seven guesses. You get ten anyway.
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion
cls

set guesses_left=10
set /a target=(!random!%%100)+1
echo I am thinking of a number between 1 and 100

:main
if "%guesses_left%"=="0" goto :lose
echo Guesses remaining: %guesses_left%
set /p "guess=Your guess: "

if "%guess%"=="%target%" goto :win
if %guess% GTR %target% echo Too high
if %guess% LSS %target% echo Too low
set /a guesses_left-=1
echo(
goto :main

:lose
echo I'm sorry, the number I was thinking of was %target%.
exit /b

:win
echo YOU WIN