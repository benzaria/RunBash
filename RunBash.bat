@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

::╔═══════════════════════════════════════════════════════════════════════╗::
::║                        RunBash MadeBy Benzaria                        ║::
::║          Run Bash Scripts and Binarys Directly from Windows           ║::
::║                Via Windows Explorer And Command Prompt                ║::
::╚═══════════════════════════════════════════════════════════════════════╝::
::  ver 1.0 >> for more info check https://github.com/benzaria/RunBash     ::

:: Default Parameters
set "Std=3"   & rem Display Standard Output And Error
set "Exit=3"  & rem Display ExitCode And Success Msg
set "NoWait=" & rem Wait For The Execution

if /i "%~x1" equ ".exe" set /a n = 1 && shift /0

:: Capturing Arguments
if "%~1" equ "" ( 
   echo  [94mUsage: [93m%~n0 [0m[Arguments] [94m^<FilePath^>[0m
   echo   ^>^> for more info : [93m%~n0 [0m-help
   exit /b 1
) else (
    if /i "%~1" equ "-Help" goto :Help
    if /i "%~1" equ "-Install" goto :Install
    set "arg_=" && set "arg=%*" && set "arg=!arg:;=¬!"
    for %%i in (!arg!) do (
        if !n! leq 0 (
            set "arg=%%~i"
            call :!arg! 2>nul
            if !ErrorLevel! neq 0 (
                if defined next (
                    set "!next!=!arg!"
                    set "next="
                ) else set "arg_=!arg_!%%i "
            )
        ) else set /a n -= 1
    )
)

:: Paths And Arguments Handling
set "arg="
for %%i in (!arg_!) do (
    if exist "%%~i" (
        for /f "delims=" %%j in (' wsl --cd "%%~dpi" pwd ') do (
           set "filepath=%%~j/%%~nxi"  
           set "arg=!arg!"!filepath!" "
        )
    ) else set "arg=!arg!%%i "
)

if defined Bin goto :!Bin!

:: Show Arguments Passed (!Gets Passed When Piping!)
rem echo [92m/bin/bash[0m !arg!

:: Output Handling
if !Std! equ 0 ( set "style=1>nul 2>&1" )
if !Std! equ 1 ( set "style=2>nul" )
if !Std! equ 2 ( set "style=1>nul" )

:: Execute The File
if defined NoWait (
    start /b "" PowerShell -NoProfile -Command "Start-Process -WindowStyle Hidden wsl.exe -ArgumentList '!root! !arg! !style!'"
) else wsl !root! !arg! !style!

echo.

:: Print Exit Msg
if !Exit! neq 0 (
    :: remove '[1A' to make a new line after the exit msg
    if !ErrorLevel! neq 0 (
        if !Exit! neq 2 (
            echo [31mScript Exited With ErrorCode=[94m!ErrorLevel![0m[1A
        ) 
    ) else if !Exit! neq 1 (
        echo [92mScript Exited With No Errors.[0m[1A 
    )
)

:: Keeping Wsl Awake For 1h For Faster Execution 
for /f "tokens=2" %%i in (' tasklist /fi "imagename eq wsl.exe" /nh ') do (
    if /i "%%~i" equ "No" (
        start /b "" PowerShell -NoProfile -Command "Start-Process -WindowStyle Hidden wsl.exe -ArgumentList 'sleep 1h && exit'"
    )
) 

endlocal
EXIT /B %ErrorLevel%

:: Select Case
    :-Root
        set "Root=-u root"
        exit /b 0
    :-NoWait
        set "NoWait=True"
        exit /b 0
    :-Std
    :-Exit
        set "next=!arg:-=!"
        exit /b 0
    :-GetBin
    :-AddBin
    :-RemBin
        set "bin_dir=%ProgramData%\RunBash\Linux-Binary"
        set "Bin=!arg:-=!"
        exit /b 0
:: End Select

:GetBin
    mkdir "!bin_dir!" 2>nul
    :: Adding The Directory To The PATH EnvVar
    echo %PATH% | find /i "!bin_dir!" >nul || PowerShell -NoProfile -Command "Start-Process -Wait -WindowStyle Hidden -Verb RunAs PowerShell -ArgumentList '-NoProfile', '-Command', \"[System.Environment]::SetEnvironmentVariable('Path', [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';!bin_dir!', [System.EnvironmentVariableTarget]::Machine)\"" 2>nul || echo [91mError: Elevated Privileges not Granted.[0m && exit /b 1
    :: Collecting All Possible Executable Files 
    for /f "delims=" %%i in (' wsl find /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /home !arg! -type l -o -type f -executable -o \^( -type f \^( -name "*.sh" -o -name "*.bash" -o -name "*.py" \^) \^) -o -path /mnt/c -prune ') do (
        :: Filtering NON Executable Files
        for %%a in ("" ".sh" ".bash" ".py") do (
            if /i "%%~xi" equ "%%~a" (
                if not exist "!bin_dir!\%%~ni.bat" (
                    set /a n += 1
                    echo [KAdding %%~i[1A
                    echo @RunBash "%%~i" %%* > "!bin_dir!\%%~ni.cmd"
                )
            )
        )
    )
    echo [K[94m!n! Links Has Been Added.[0m
    endlocal & set "PATH=%ProgramData%\RunBash\Linux-Binary;%PATH%"
    exit /b 0

:AddBin
    for /f "tokens=1* delims=¬" %%i in ("!arg!") do (
        for /f "tokens=1*" %%a in ("%%i") do (
            echo %%~a -^> %%~b
            echo @RunBash %%~b %%* > "!bin_dir!\%%~a.bat"
            del "!bin_dir!\%%~a.cmd" 2>nul
        )
        set "arg=%%j"
    )
    if defined arg goto :AddBin
    exit /b 0

:RemBin
    if not defined arg (
        choice /n /m "Are You Sure, Delete All Links (yes|no)"
        if !errorlevel! equ 1 (
            del /q "!bin_dir!"
            echo [91mAll Links has been Deleted.[0m
        )
    )
    for %%i in (!arg!) do del "!bin_dir!\%%~i.*"
    exit /b 0

:Install
    net session >nul 2>&1
    if !ErrorLevel! neq 0 (
        PowerShell -NoProfile -Command "Start-Process -Wait -Verb RunAs -WindowStyle Hidden \"%~0\" -ArgumentList '-Install \"%~2\" \"%~3\"'" 2>nul || echo [91mError: Elevated Privileges not Granted.[0m
        exit /b 1
    )

    if "%~2" neq "" ( set "istl_dir=%~2" ) else set "istl_dir=%windir%\RunBash.exe"
    if "%~3" neq "" ( set "edit_dir=%~3" ) else set "edit_dir=%windir%\notepad.exe"
    copy "%~0" "!istl_dir!" >nul 2>&1 || mshta vbscript:msgbox("Error: Installing Failed, Install Path is Incorrect!",vbinformation,"RunBash Installer")(window.close) && exit /b 1

    reg add "HKEY_CLASSES_ROOT\bashfile" /ve /d "Linux Bash File" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\DefaultIcon" /ve /d "!istl_dir!,0" /f >nul

    reg add "HKEY_CLASSES_ROOT\bashfile\shell" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\shell\open" /v Icon /d "!istl_dir!,0" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\shell\open\command" /ve /d "\"!istl_dir!\" \"%%1\" %%*" /f >nul

    reg add "HKEY_CLASSES_ROOT\bashfile\shell\1open" /ve /d "Run as Root" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\shell\1open" /v Icon /d "!istl_dir!,1" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\shell\1open\command" /ve /d "\"!istl_dir!\" -root \"%%1\" %%*" /f >nul

    reg add "HKEY_CLASSES_ROOT\bashfile\shell\edit" /v Icon /d "\"!edit_dir!\"" /f >nul
    reg add "HKEY_CLASSES_ROOT\bashfile\shell\edit\command" /ve /d "\"!edit_dir!\" \"%%1\"" /f >nul

    reg add "HKEY_CLASSES_ROOT\.sh" /ve /d "bashfile" /f >nul
    reg add "HKEY_CLASSES_ROOT\.bash" /ve /d "bashfile" /f >nul
    reg add "HKEY_CLASSES_ROOT\.bashrc" /ve /d "bashfile" /f >nul

    reg add "HKEY_CLASSES_ROOT\.sh\ShellNew" /ve /f >nul
    reg add "HKEY_CLASSES_ROOT\.sh\ShellNew" /v NullFile /d "" /f >nul

    if !ErrorLevel! equ 0 mshta vbscript:msgbox("Registry entries have been added successfully.",vbinformation,"RunBash Installer")(window.close)
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    timeout /t 2 >nul
    exit /b 0

:Help
    echo [95m
    echo  ╔═══════════════════════════════════════════════════════════════════════╗
    echo  ║                        RunBash MadeBy Benzaria                        ║
    echo  ║          Run Bash Scripts and Binarys Directly from Windows           ║
    echo  ║                Via Windows Explorer And Command Prompt                ║
    echo  ╚═══════════════════════════════════════════════════════════════════════╝[94m
    echo    ver 1.0 [0m^>^> for more info check [4;90mhttps://github.com/benzaria/RunBash[0m
    echo [93m
    echo    %~n0 [0m[Wsl-Arguments] [RunBash-Arguments] [94m^<File-Path^>[0m [File-Arguments]
    echo or[94m
    echo   ^<File-Path^>[0m [File-Arguments] [RunBash-Arguments]
    echo [7m
    echo [Wsl-Arguments][0m for info ^>^>[94m Wsl[0m --help
    echo [7m
    echo [RunBash-Arguments]
    echo [0;94m
    echo    -GetBin [96m^<dirs^> [0mGather all Executable files from the Linux Distribution
    echo                   And Link them to the Windows Path EnvVar. default dirs :
    echo                   ([90m/usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /home[0m)
    echo [94m
    echo    -RemBin [96m^<name^> [0mRemove Added Commands To Windows, if no name specified 
    echo                   All Links will be Removed After a Confirmation message
    echo                   ([93m%~n0[90m -RemBin [96mls sudo find grep apt gcc py vim [0m...)
    echo [94m
    echo    -AddBin [96m^<name-1^> [95m^<cmd-para-1^> [91m; [96m^<name-2^> [95m^<cmd-para-2^> [91m; [0m...
    echo                   Add Custom Commands with parameters from Linux To Windows
    echo                   ([93m%~n0[90m -AddBin [96mll [95mls --color=auto -l [91m; [96mla [95mls -a [0m)
    echo [94m
    echo    -Install [96m^<install-path^> ^<editor-path^>[0m
    echo                   Install ContextMenu and RunBash Plugins to Explorer and Cmd
    echo                   the chosen install-path needs to be defined in the PATH EnvVar
    echo                   (default :[90m "%windir%\%~nx0" "%windir%\notepad.exe"[0m)
    echo [94m
    echo    -NoWait [0m       Don't Wait For The Execution to Finish
    echo [94m
    echo    -Root [0m         Run File With Root User Privileges
    echo [94m
    echo    -Std  [96m^<0-2^>[0m    0: Don't Display any Output
    echo                   1: Display only Standard Output
    echo                   2: Display only Standard Error
    echo [94m
    echo    -Exit [96m^<0-2^>[0m    0: Don't Display a thing on Exit
    echo                   1: Display The ErrorCode on Exit
    echo                   2: Display A Success Msg on Exit
    echo [91m
    echo | set /p="[]         ^!^! Wsl is needed for The program to run properly ^!^!"
    echo [0m
    echo [1m
    echo  ^> The RunBash Source Code is Located at \ProgramData\RunBash\RunBash.bat
    echo     [91mBe Aware That[0;1m Modifying The Source Code Effects The RunBash Execution[0m
    exit /b 0
