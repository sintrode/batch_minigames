::------------------------------------------------------------------------------
:: NAME
::     Pico, Fermi, Bagels
::
:: USAGE
::     bagels.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     The computer thinks of a three-digit number where no two digits are the
::     same. The player guesses what the number is and the computer responds:
::         PICO   - One digit is correct, but in the wrong place
::         FERMI  - One digit is in the correct place
::         BAGELS - No digit is correct
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

:: Increase this to make the game easier, decrease it to make it harder
set "MAX_GUESSES=15"

:init
cls
echo I am thinking of a three-digit number. None of the digits are the same. I will
echo tell you when you get close:
echo(
echo PICO means that one digit is correct, but in the wrong place
echo FERMI means that one digit is in the correct place
echo BAGELS means that none of the digits are correct
pause

:pick1
set /a digit[0]=(!random!%%9)+1

:pick2
set /a digit[1]=!random!%%10
if "!digit[0]!"=="!digit[1]!" goto :pick2

:pick3
set /a digit[2]=!random!%%10
if "!digit[0]!"=="!digit[2]!" goto :pick3
if "!digit[1]!"=="!digit[2]!" goto :pick3

set /a guesses_left=%MAX_GUESSES%
:main
if "%guesses_left%"=="0" goto :lose

cls
echo Guesses remaining: %guesses_left%

:: Give the guess an invalid value in case the user enters nothing
set "guess=0"

set /p "guess=Your guess: "
call :validate_guess %guess% || (
	echo Invalid selection. Please enter a three-digit number.
	echo Remember that none of the digits will be the same.
	pause
	goto :main
)

set pico=0
set fermi=0
for /L %%A in (0,1,2) do (
	for /L %%B in (0,1,2) do (
		if "!digit[%%A]!"=="!num[%%B]!" (
			if "%%A"=="%%B" (set /a fermi+=1) else (set /a pico+=1)
		)
	)
)

if !fermi! EQU 3 goto :win
if !pico! equ 0 (
	if !fermi! equ 0 (
		echo BAGELS
	) else (
		for /L %%A in (1,1,!fermi!) do echo FERMI
	)
) else (
	for /L %%A in (1,1,!pico!) do echo PICO
	if !fermi! GTR 0 for /L %%A in (1,1,!fermi!) do echo FERMI
)
pause
set /a guesses_left-=1
goto :main

exit /b

:lose
echo You lose^^! The numnber I was thinking of was !digit[0]!!digit[1]!!digit[2]!
pause
exit /b

:win
echo YOU GOT IT^!
pause
exit /b

::------------------------------------------------------------------------------
:: Checks that the user entered a number and that the numbers are not the same
::
:: Arguments: %1 - the number guessed by the player
:: Returns:   1 if the number is invalid, 0 otherwise
::------------------------------------------------------------------------------
:validate_guess
set is_valid=0
set "fail=set is_valid=1"
for /f "delims=0123456789" %%A in ("%~1") do %fail%
set "number=%~1"

if !number! lss 100 %fail%
if !number! gtr 999 %fail%

for /L %%A in (0,1,2) do set num[%%A]=!number:~%%A,1!
if "!num[0]!"=="!num[1]!" %fail%
if "!num[0]!"=="!num[2]!" %fail%
if "!num[1]!"=="!num[2]!" %fail%
:: So many ways to fail... o_O

exit /b %is_valid%