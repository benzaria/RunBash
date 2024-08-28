@echo off
copy %ProgramData%\RunBash\RunBash.bat %ProgramData%\RunBash\RunBash.old >nul 2>&1
del  %ProgramData%\RunBash\RunBash.bat 2>nul
%~dp0RunBash -Install 
%~dp0RunBash -GetBin 
%~dp0RunBash -AddBin ls ls --color=auto ; ll ls --color=auto -l ; la ls --color=auto -a ; lla ls --color=auto -la ; l ls --color=auto -CF
%~dp0RunBash -AddBin grep grep --color=auto ; fgrep fgrep --color=auto ; egrep egrep --color=auto ; ip ip --color=auto ; diff diff --color=auto
%~dp0RunBash -Help
