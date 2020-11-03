::------------------------------------------------------------------------------
:: NAME
::     Slot Machine
::
:: USAGE
::     slots.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     A simple single-row slot machine because I'm lazy. Top and bottom rows
::     may be added in a future release.
::
::     PAY TABLE
::         SEVEN  SEVEN  SEVEN  - $100
::         BAR    BAR    BAR    - $75
::         CHERRY CHERRY CHERRY - $50
::         BELL   BELL   BELL   - $25
::         OTHER MATCH THREE    - $20
::         TWO SEVENS           - $10
::         OTHER MATCH TWO      - $1
::         
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion
cls

set money=100
set array_string="      ,SEVEN , BAR  ,CHERRY, BELL ,LEMON , STAR ,APPLE "
call :make_array item %array_string% -2

for /L %%A in (1,1,3) do set "roll_%%A=-1"

:main
cls
echo Spinning costs $1
echo You have $!money!
echo(
echo Press S to spin to Q to quit
choice /C:SQ /N >nul
if "!errorlevel!"=="2" exit /b
if !money! leq 0 (
	echo You are out of money. Please leave the casino.
	pause >nul
	exit /b
)

set /a money-=1
set /a roll_1=!random!%%7
set /a roll_2=!random!%%7
set /a roll_3=!random!%%7

echo(
echo( [!item[%roll_1%]!] [!item[%roll_2%]!] [!item[%roll_3%]!]
echo(

if "%roll_1%"=="%roll_2%" (
	if "%roll_1%"=="%roll_3%" (
		call :jackpot %roll_1%
	) else (
		call :win_two %roll_1%
	)
) else (
	if "%roll_1%"=="%roll_3%" call :win_two %roll_1%
	if "%roll_2%"=="%roll_3%" call :win_two %roll_2%
)

pause
goto :main

::------------------------------------------------------------------------------
:: Win a large prize for matching all three rollers
::
:: Arguments: %1 - the index of the roller
:: Returns:   None
::------------------------------------------------------------------------------
:jackpot
set /a money+=20
echo THREE OF A KIND

:: This is one of those times it would be really nice to have a switch command
if "%~1"=="0" (
	echo J A C K P O T ^! ^! ^!
	set /a money+=80
) else if "%~1"=="1" (
	echo A L L   B A R S ^! ^! ^!
	set /a money+=55
) else if "%~1"=="2" (
	echo C H E R R I E S ^! ^! ^!
	set /a money+=30
) else if "%~1"=="3" (
	echo DO YOU HEAR THE BELLS???
	set /a money+=5
)

exit /b

::------------------------------------------------------------------------------
:: Win your money back for spinning two matching symbols, or get $10 for sevens
::
:: Arguments: %1 - the index of the roller
:: Returns:   None
::------------------------------------------------------------------------------
:win_two
set /a money+=1
echo PAIR

if "%~1"=="0" (
	echo SEVENS ^! ^!
	set /a money+=9
) else (
	echo You win your money back
)
exit /b

::------------------------------------------------------------------------------
:: Recursively creates an array from a comma-delimited string
::------------------------------------------------------------------------------
:make_array
set /a array_index=%3+1
if not "%~2"=="" (
	for /F "tokens=1,* delims=," %%A in ("%~2") do (
		set %1[%array_index%]=%%A
		call :make_array %1 "%%B" %array_index%
	)
)