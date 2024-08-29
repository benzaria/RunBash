# RunBash by Benzaria

## Overview
**RunBash** is a handful utility that enables you to run your Bash Scripts and Linux Binarys directly from your Windows system, seamlessly integrating Linux commands into your Windows environment. Whether through Windows Explorer or the Command Prompt, RunBash offers a versatile and efficient way to execute Bash scripts and Binarys without the need for a separate terminal.

## Table of Contents
 - [Features](#features)
 - [Getting Started](#getting-started)
 - [Installation](#installation)
 - [Usage](#usage)
 - [Arguments](#arguments)
 - [Details](#details)


## Features
- **Direct Seamless Execution:** Run Bash scripts and Linux binarys from Windows Explorer or the Command Prompt with ease.
- **Linux Command Integration:** Easily link and manage Linux commands within your Windows environment.
- **Context Menu Plugins:** Add Multiple Option to the context menu from: Open, Run as Root, Run as Admin, Edit, and New Bash File. [Details](#details)
- **Customizable Execution:** Use various parameters to control output, error handling, and execution behavior.
- **Root/Admin Access:** Optionally run scripts with Root or Admin privileges.
- **Error and Output Handling:** Fine-tune what outputs and errors are displayed or hidden.

## Getting Started
### Prerequisites
- **WSL (Windows Subsystem for Linux)** is required for RunBash to function. Please ensure that WSL is installed on your system.  
  - Quick install : `wsl --install && shutdown /r` optional : `wsl --set-default-version 2` if supported !

### Installation
 1. Clone the Repository `Git Clone https://github.com/benzaria/RunBash.git`  
or  
 2. Download the Latest Release [RunBash v1.3](https://github.com/benzaria/RunBash/archive/refs/tags/1.3.zip).  

### Usage
RunBash can be invoked directly from the Command Prompt. Here are the basic usage instructions:

First run `setup.bat` it will do all the work to make sure RunBash is setup perfectly.  
\- else run `RunBash -Install & RunBash -GetBin` for Basic setup !  

```
Usage:
 RunBash [Wsl-Arguments] [RunBash-Arguments] <File-Path> [File-Arguments]  
or after setting up 
 <File-Path> [File-Arguments] [RunBash-Arguments]
```

#### Example:
```
 RunBash -Std 1 -Exit 1 -Root C:\Users\benz\sleepsort.sh
or after setting up
 C:\Users\benz\sleepsort.sh -Std 1 -Exit 1 -Root
```

### Arguments
- **[Wsl-Arguments]:** Standard arguments passed to WSL. For more info, run `wsl --help`.
- **[RunBash-Arguments]:**
  - `-Install <install-path> <editor-path>`: Install ContextMenu and RunBash Plugins to Explorer and Cmd. [Details](#details)
  - `-GetBin <dirs>`: Gather all executable files from specified Linux directories and link them to Windows.
  - `-AddBin <name1> <cmd-para-1> ; <name2> <cmd-para-2> ;...`: Add custom commands from Linux to Windows.
  - `-RemBin <name>`: Remove specified or all linked commands from Windows.
  - `-NoWait`: Do not wait for script execution to finish.
  - `-Root`: Run the script as the root user.
  - `-Std <0-2>`: Control output display:
    - `0`: No output
    - `1`: Display Standard output only
    - `2`: Display Standard error only
  - `-Exit <0-2>`: Control exit message display:
    - `0`: No exit message
    - `1`: Display error code on exit
    - `2`: Display success message on exit

#### Help
For a detailed guide on using RunBash, run: `RunBash -Help`

### Details
![Explorer/Context Menu](/images/ContextMenu.png)
![RunBash in Action](/images/RunBash%20in%20Action%20(1).png)
![RunBash in Action](/images/RunBash%20in%20Action%20(2).png)
> [!IMPORTANT]
> Make sure to run either the commands `runbash -addbin <name> <pkg>` or `runbash -getbin` after installing a new package  
> :bulb: Coming soon : Automatic Link after a new package install

![RunBash in Action](/images/RunBash%20in%20Action%20(3).png)

## Contribution
Feel free to contribute by submitting issues or pull requests. Any enhancements or bug fixes are welcome!

## Acknowledgments
Special thanks to the creators of WSL for making tools like RunBash possible.
