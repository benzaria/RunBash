#include <stdio.h>
#include <string.h>
#include <windows.h>

//╔═══════════════════════════════════════════════════════════════════════╗//
//║                        RunBash MadeBy Benzaria                        ║//
//║          Run Bash Scripts and Binaries Directly from Windows          ║//
//║                Via Windows Explorer And Command Prompt                ║//
//╚═══════════════════════════════════════════════════════════════════════╝//
//  ver 1.3 >> for more info check https://github.com/benzaria/RunBash     //

// Check if a file exists
int file_exists(const char *path) {
    DWORD attrib = GetFileAttributes(path);
    return (attrib != INVALID_FILE_ATTRIBUTES && !(attrib & FILE_ATTRIBUTE_DIRECTORY));
}

// Check if a directory exists, else create it
void dir_exists(const char *dir_path) {
    DWORD attrib = GetFileAttributes(dir_path);

    if (attrib == INVALID_FILE_ATTRIBUTES || !(attrib & FILE_ATTRIBUTE_DIRECTORY)) {
        if (!CreateDirectory(dir_path, NULL)) {
            printf("Error: Could not Create RunBash directory %s.\n", dir_path);
            exit(1);
        }
    }
}

// Extract the embedded RunBash and save it to disk
void extract_RunBash(const char *file_path) {
    HRSRC hRes = FindResource(NULL, "RunBash", RT_RCDATA);
    HGLOBAL hResData = LoadResource(NULL, hRes);
    DWORD resSize = SizeofResource(NULL, hRes);
    void *pResData = LockResource(hResData);

    if (hRes == NULL || hResData == NULL || pResData == NULL) {
        printf("Error: Could not Extract RunBash resource.\n");
        return;
    }

    FILE *outputFile = fopen(file_path, "wb");
    if (outputFile == NULL) {
        printf("Error: Could not Create RunBash file %s.\n", file_path);
        return;
    }
    fwrite(pResData, 1, resSize, outputFile);
    fclose(outputFile);
}

// Handle special characters in arguments
void handle_argument(char *dest, const char *src) {
    if (strpbrk(src, " =\",")) {
        strcat(dest, "\"");
        strcat(dest, src);
        strcat(dest, "\"");
    } else {
        strcat(dest, src);
    }
}

// Run RunBash with arguments
void RunBash(const char *file_path, int argc, char *argv[]) {
    char command[4096] = {0};
    snprintf(command, sizeof(command), "cmd /c \"\"%s\"", file_path);

    for (int i = 0; i < argc; i++) {
        strcat(command, " ");
        handle_argument(command, argv[i]);
    }

    strcat(command, "\"");
    system(command);
}

// Get the full path based on %ProgramData%
void get_full_path(char *full_dir_path, const char *subdir, char *full_file_path, const char *filename, char *full_exe_path) {
    char programData[MAX_PATH];
    GetModuleFileName(NULL, full_exe_path, MAX_PATH);
    GetEnvironmentVariable("ProgramData", programData, MAX_PATH);

    snprintf(full_dir_path, MAX_PATH, "%s\\%s", programData, subdir);
    snprintf(full_file_path, MAX_PATH, "%s\\%s", full_dir_path, filename);
}

// Get the full path of the executable
void get_exe_path(char *full_path, int size) {
    if (!GetModuleFileName(NULL, full_path, size)) {
        printf("Error: Could not get the full path of the executable.\n");
        exit(1);
    }
}

int main(int argc, char *argv[]) {
    char exe_path[MAX_PATH];
    char dir_path[MAX_PATH];
    char file_path[MAX_PATH];

    // Get the directory, file and exe paths
    get_full_path(dir_path, "RunBash", file_path, "RunBash.bat", exe_path);

    // Check if the RunBash already exists
    if (!file_exists(file_path)) {
        dir_exists(dir_path);
        extract_RunBash(file_path);
    }
    
    argv[0] = exe_path;
    RunBash(file_path, argc, argv);

    return 0;
}
