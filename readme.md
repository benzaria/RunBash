# RunBash by Benzaria

## Overview
**RunBash** is a powerful utility that enables you to run your Bash scripts directly from your Windows system, seamlessly integrating Linux commands into your Windows environment. Whether through Windows Explorer or the Command Prompt, RunBash offers a versatile and efficient way to execute Bash scripts without the need for a separate terminal.

## Features
- **Direct Bash Script Execution:** Run your Bash scripts from Windows Explorer or the Command Prompt with ease.
- **Customizable Execution:** Use various parameters to control output, error handling, and execution behavior.
- **Linux Command Integration:** Easily link and manage Linux commands within your Windows environment.
- **Root Access:** Optionally run scripts with root privileges.
- **Error and Output Handling:** Fine-tune what outputs and errors are displayed or hidden.

## Getting Started
### Prerequisites
- **WSL (Windows Subsystem for Linux)** is required for RunBash to function properly. Please ensure that WSL is installed and configured on your system.

### Installation
1. Clone or download the [RunBash repository](https://github.com/benzaria/RunBash).
2. Copy the `RunBash.bat` file to your desired location or add it to your system PATH for global access.

### Usage
RunBash can be invoked directly from the Command Prompt. Here are the basic usage instructions:

```bash
RunBash [Wsl-Arguments] [RunBash-Arguments] <File-Path> [File-Arguments]
```

#### Example:
```bash
RunBash -Std 1 -Exit 1 -Root /path/to/script.sh
```

### Arguments
- **Wsl-Arguments:** Standard arguments passed to WSL. For more info, run `wsl --help`.
- **RunBash-Arguments:**
  - `-GetBin <dirs>`: Gather all executable files from specified Linux directories and link them to Windows.
  - `-RemBin <name>`: Remove specified or all linked commands from Windows.
  - `-AddBin <name1> <cmd-para-1> # <name2> <cmd-para-2> ...`: Add custom commands from Linux to Windows.
  - `-NoWait`: Do not wait for script execution to finish.
  - `-Root`: Run the script as the root user.
  - `-Std <0-2>`: Control output display:
    - `0`: No output
    - `1`: Standard output only
    - `2`: Standard error only
  - `-Exit <0-2>`: Control exit message display:
    - `0`: No exit message
    - `1`: Display error code on exit
    - `2`: Display success message on exit

### Help
For a detailed guide on using RunBash, run:
```bash
RunBash -help
```

## Contribution
Feel free to contribute by submitting issues or pull requests. Any enhancements or bug fixes are welcome!

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
Special thanks to the open-source community and the creators of WSL for making tools like RunBash possible.
