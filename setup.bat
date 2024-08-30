@echo off
echo > "%temp%\msgbox"
echo @set "PATH=%PATH%;%ProgramData%\RunBash\Linux-Binary\" > "%temp%\setpath.bat"
for /f %%i in (' dir /b RunBash*.exe ') do set "RunBash=%%~fi"
"%RunBash%" -Install " " "C:\Users\benz\AppData\Local\Programs\Microsoft VS Code\Code.exe"
"%RunBash%" -GetBin 
"%RunBash%" -AddBin ls ls --color=auto ; ll ls --color=auto -l ; la ls --color=auto -a ; lla ls --color=auto -la ; l ls --color=auto -CF
"%RunBash%" -AddBin grep grep --color=auto ; fgrep fgrep --color=auto ; egrep egrep --color=auto ; ip ip --color=auto ; diff diff --color=auto
"%RunBash%" -Help
wt -w 0 cmd /k "%temp%\setpath.bat" ^&^& del "%temp%\setpath.bat" 2>nul