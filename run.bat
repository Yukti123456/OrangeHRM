@echo off
cd /d %~dp0

echo Activating virtual environment...
call venv\Scripts\activate

echo Running tests...
robot "TestCases\Testcases.robot"

echo Done!
pause
