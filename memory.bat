::------------------------------------------------------------------------------
:: NAME
::     Memory
::
:: USAGE
::     memory.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     Tiles are arranged in a 6x6 grid and numbered 01 through 36. Enter two
::     digits to see what the values of the cards are. If they match, the tiles
::     are removed. This continues until all tiles are gone.
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

:: Symbols don't always appear correctly, so we'll just match letters
:init
set "symbols=ABCDEFGHIJKLMNOPQR"
for /L %%A in (0,1,17) do (
	set "cards[%%A]=!symbols:~%%A,1!"
	set /a double=%%A+18
	set "cards[!double!]=!symbols:~%%A,1!"
)

:: Cue "Harry Truman" by Mindless Self Indulgence
<nul set /p "=Shuffling the deck... "

:: Normally I'd be using a for /L loop here, but you can't have labels in loops
set "shuffle_counter=0"
set "SHUFFLE_MAX=300"

:shuffle
set /a card_1=!random!%%36

:: This is its own label so that we don't waste time repicking a first card
:: if we pick the same card twice in a row and need to start over
:pick_second_card
set /a card_2=!random!%%36
if "!card_1!"=="!card_2!" goto :pick_second_card

set "temp_card=!cards[%card_1%]!"
set "cards[%card_1%]=!cards[%card_2%]!"
set "cards[%card_2%]=!temp_card!"
set /a shuffle_counter+=1
set /a percent=shuffle_counter/3
title Shuffling %percent%%% complete
if not "!shuffle_counter!"=="!SHUFFLE_MAX!" goto :shuffle
echo done
title Memory Game

::------------------------------------------------------------------------------
:: [01] [02] [03] [04] [05] [06]
:: [07] [08] [09] [10] [11] [12]
:: [13] [14] [15] [16] [17] [18]
:: [19] [20] [21] [22] [23] [24]
:: [25] [26] [27] [28] [29] [30]
:: [31] [32] [33] [34] [35] [36]
::------------------------------------------------------------------------------
:display_deck
cls
for /L %%A in (0,1,5) do (
	for /L %%B in (1,1,6) do (
		set /a tile_num=^(6*%%A^)+%%B-1
		set /a tile_face=tile_num+1
		set "tile_face=0!tile_face!"
		set "tile_face=!tile_face:~-2!
		
		if not defined cards[!tile_num!] (
			<nul set /p "=. [  ]"
		) else (
			<nul set /p "=^. [!tile_face!]"
		)
	)
	echo(
)
echo(
echo(

set /p "first_card=First card: "
set /p "second_card=Second card: "

if /I "%first_card%"=="quit" exit /b

call :isnum %first_card% || (echo Invalid entry & pause & goto :display_deck)
call :isnum %second_card% || (echo Invalid entry & pause & goto :display_deck)
if "!first_card!"=="!second_card!" (
	echo Please pick two different cards.
	pause
	goto :display_deck
)

:: Off-by-one errors are making me do the most ridiculous stuff
call :get_card_index %first_card%
set pick_1=!errorlevel!
call :get_card_index %second_card%
set pick_2=!errorlevel!

:: No sense in picking cards that aren't there
if not defined cards[%pick_1%] (
	echo Card %first_card% is no longer on the table.
	pause
	goto :display_deck
)
if not defined cards[%pick_2%] (
	echo Card %second_card% is no longer on the table.
	pause
	goto :display_deck
)

echo Card %first_card% is !cards[%pick_1%]!
echo Card %second_card% is !cards[%pick_2%]!

if "!cards[%pick_1%]!"=="!cards[%pick_2%]!" (
	echo It's a match^^^!
	set "cards[%pick_1%]="
	set "cards[%pick_2%]="
)

:: Are we done yet?
set "still_there=F"
for /L %%A in (0,1,35) do if defined cards[%%A] set "still_there=T"
if "%still_there%"=="F" goto :win

pause
goto :display_deck
exit /b

:win
echo CONGRATULATIONS^^!
exit /b

::------------------------------------------------------------------------------
:: Validates that user input is not only a valid number, but also 1-36
::
:: Arguments: %1 - The string to validate
:: Returns:   0 if the string is numeric, 1 otherwise
::------------------------------------------------------------------------------
:isnum
set is_num=0
for /f "delims=1234567890" %%A in ("%~1") do set "is_num=1"

if %~1 LSS 1 set "is_num=1"
if %~1 GTR 36 set "is_num=1"
exit /b %is_num%

::------------------------------------------------------------------------------
:: Strips the leading 0 from the number and then subtracts 1 to return the index
:: of the card in the array based on its face value
::
:: Arguments: %1 - The card to process
:: Returns:   %1-1
::------------------------------------------------------------------------------
:get_card_index
set card_index=0%~1
set card_index=!card_index:~-2!
set /a card_index=1!card_index!-100-1
exit /b %card_index%