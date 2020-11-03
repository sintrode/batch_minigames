::------------------------------------------------------------------------------
:: NAME
::    Treasure Hunt
::
:: USAGE
::     treasure.bat
::
:: AUTHOR
::     sintrode
::
:: DESCRIPTION
::     Find the hidden treasure somewhere in a 10x10 grid. If you miss, your
::     crew will tell you how far away you were. You have 10 attempts before
::     your drill runs out of fuel.
::
:: THANKS
::     Math code from https://www.dostips.com/forum/viewtopic.php?t=5819
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion
cls
echo Captain, we're detecting treasure.

:init
set "Abs(x)=(((x)>>31|1)*(x))"
set "Sqrt(N)=( M=(N), x=M/(11*1024)+40, x=(M/x+x)>>1, x=(M/x+x)>>1, x=(M/x+x)>>1, x=(M/x+x)>>1, x=(M/x+x)>>1, x+=(M-x*x)>>31 )"
set "printn=<nul set /p="

set "drill_uses=10"
set /a treasure_x=!RANDOM!%%10
set /a treasure_y=!RANDOM!%%10
for /L %%A in (0,1,9) do for /L %%B in (0,1,9) do (
	set "grid[%%A][%%B]=nothing"
	set "tries[%%A][%%B]=."
)
set "grid[%treasure_y%][%treasure_x%]=THE TREASURE"

:draw_grid
if "%drill_uses%"=="0" goto :lose
cls
echo Drill uses remaining: %drill_uses%
for /L %%A in (9,-1,1) do (
	%printn% %%A
	for /L %%B in (0,1,9) do (
		%printn%. !tries[%%A][%%B]!
	)
	echo(
)
echo(  0 1 2 3 4 5 6 7 8 9
echo(
echo(

:: Unset the coordinates to throw an error if no value is entered
set "drill_x="
set "drill_y="

set /p "drill_x=Horizontal coordinate: "
set /p "drill_y=Vertical coordinate: "
if not defined grid[%drill_y%][%drill_x%] (
	echo Captain, that location is not on the map.
	pause
	goto :draw_grid
)
set /a drill_uses-=1
echo You found !grid[%drill_y%][%drill_x%]!
set "tries[%drill_y%][%drill_x%]=O"
if "%drill_x%"=="%treasure_x%" if "%drill_y%"=="%treasure_y%" goto :win


:: Report the distance from the drill site to the treasure
set /a dist_x=treasure_x-drill_x, dist_y=treasure_y-drill_y
set /a "x=dist_x, abs_dist_x=%Abs(x)%"
set /a "x=dist_y, abs_dist_y=%Abs(x)%"
set /a square_sum=(abs_dist_x*abs_dist_x)+(abs_dist_y*abs_dist_y)
set /a "N=square_sum, treasure_distance=%Sqrt(N)%"
echo(
echo(Captain, sensors report the treasure is %treasure_distance% squares away

pause
goto :draw_grid

:lose
echo Captain, the drill has become unusable. We must leave.
pause
exit /b

:win
echo Congratulations, Captain.