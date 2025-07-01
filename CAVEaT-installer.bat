@echo off
setlocal EnableDelayedExpansion

:: CAVEaT Toolkit Installer for Windows
:: Cloud Adversarial Vectors, Exploits, and Threats Setup
:: Version 1.0

echo.
echo  ===============================================================
echo  =                 CAVEaT Toolkit Installer                   =
echo  =        Cloud Security Alliance Development Setup           =
echo  =                      Version 1.0                          =
echo  =                       Windows                              =
echo  ===============================================================
echo.
echo  [*] Setting up your CAVEaT development environment...
echo.

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  [!] This installer requires administrator privileges.
    echo  [TIP] Please right-click and "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo  [OK] Administrator privileges confirmed
echo.

:: Set installation directory - use a different name to avoid conflicts
set INSTALL_DIR=%USERPROFILE%\caveat-installation
echo  [DIR] Creating installation directory: %INSTALL_DIR%

:: Only clean up if user explicitly agrees
if exist "%INSTALL_DIR%" (
    echo  [!] Installation directory already exists.
    choice /M "Do you want to clean it up and start fresh"
    if !errorlevel! equ 1 (
        echo  [CLEAN] Cleaning up existing installation...
        rmdir /s /q "%INSTALL_DIR%" 2>nul
    ) else (
        echo  [DIR] Using existing directory...
    )
)

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if %errorlevel% neq 0 (
        echo  [ERROR] Failed to create installation directory
        pause
        exit /b 1
    )
)

cd /d "%INSTALL_DIR%"
echo  [OK] Installation directory ready
echo.

:: Check for Git
echo  [CHK] Checking for Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  [PKG] Installing Git...
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  [ERROR] Failed to install Git
        echo  [TIP] Please install Git manually from: https://git-scm.com/
        pause
        exit /b 1
    )
    echo  [OK] Git installed successfully
    echo  [RESTART] Please restart your command prompt and run this installer again
    pause
    exit /b 0
) else (
    echo  [OK] Git is already installed
)
echo.

:: Check for Node.js
echo  [CHK] Checking for Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  [PKG] Installing Node.js...
    winget install OpenJS.NodeJS --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  [ERROR] Failed to install Node.js
        echo  [TIP] Please install Node.js manually from: https://nodejs.org/
        pause
        exit /b 1
    )
    echo  [OK] Node.js installed successfully
    echo  [RESTART] Please restart your command prompt and run this installer again
    pause
    exit /b 0
) else (
    echo  [OK] Node.js is already installed
)
echo.

:: Check for GitHub CLI
echo  [CHK] Checking for GitHub CLI...
gh --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  [PKG] Installing GitHub CLI...
    winget install GitHub.cli --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  [ERROR] Failed to install GitHub CLI
        echo  [TIP] Please install GitHub CLI manually
        pause
        exit /b 1
    )
    echo  [OK] GitHub CLI installed successfully
) else (
    echo  [OK] GitHub CLI is already installed
)
echo.

:: Clone the CAVEaT repository
echo  [DL] Downloading CAVEaT repository...
if not exist "CAVEaT" (
    git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git CAVEaT 2>nul
    if %errorlevel% neq 0 (
        echo  [ERROR] Failed to download CAVEaT repository
        echo  [TIP] Please check your internet connection and try again
        pause
        exit /b 1
    )
    echo  [OK] CAVEaT repository downloaded successfully
) else (
    echo  [OK] CAVEaT repository already exists
)
echo.

:: Create workspace directory
set WORKSPACE_DIR=%USERPROFILE%\caveat-workspace
echo  [DIR] Creating workspace directory: %WORKSPACE_DIR%

if not exist "%WORKSPACE_DIR%" (
    mkdir "%WORKSPACE_DIR%" 2>nul
)

cd /d "%WORKSPACE_DIR%"

:: Clone repositories to workspace
echo  [DL] Setting up workspace repositories...

if not exist "CAVEaT" (
    git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git CAVEaT 2>nul
    if %errorlevel% neq 0 (
        echo  [!] Could not clone CAVEaT to workspace
    ) else (
        echo  [OK] CAVEaT cloned to workspace
    )
)

if not exist "cti" (
    git clone https://github.com/CloudSecurityAlliance/cti.git cti 2>nul
    if %errorlevel% neq 0 (
        echo  [!] Could not clone CTI repository
        echo  [TIP] You can manually clone it later if needed
    ) else (
        echo  [OK] CTI repository cloned to workspace
    )
)

:: GitHub authentication and forking
echo.
echo  [AUTH] Setting up GitHub authentication...
echo  [TIP] You can fork repositories later for contributing
echo.

gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo  [AUTH] GitHub authentication required for forking repositories
    choice /M "Do you want to authenticate with GitHub now"
    if !errorlevel! equ 1 (
        gh auth login
        if %errorlevel% equ 0 (
            echo  [OK] GitHub authentication successful
            echo.
            choice /M "Do you want to fork the repositories to your GitHub account"
            if !errorlevel! equ 1 (
                echo  [FORK] Forking CAVEaT repository...
                gh repo fork CloudSecurityAlliance-WG/CAVEaT --clone=false 2>nul
                echo  [FORK] Forking CTI repository...
                gh repo fork CloudSecurityAlliance/cti --clone=false 2>nul
                echo  [OK] Repositories forked successfully
            )
        ) else (
            echo  [!] GitHub authentication failed
            echo  [TIP] You can authenticate later with: gh auth login
        )
    )
) else (
    echo  [OK] Already authenticated with GitHub
)

:: Create reference files
echo.
echo  [FILE] Creating reference files...

echo # CAVEaT Quick Reference > "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo. >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo ## Your Configuration >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **Platform**: Windows >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **Installation**: %INSTALL_DIR% >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **Workspace**: %WORKSPACE_DIR% >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo. >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo ## Repository Locations >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **CTI Repository**: %WORKSPACE_DIR%\cti >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **CAVEaT Repository**: %WORKSPACE_DIR%\CAVEaT >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo. >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo ## Important Paths >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **CAVEaT Prompts**: CAVEaT\prompts\ >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **STIX Objects**: cti\ (if available) >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo - **CAVEaT Data**: CAVEaT\data\ >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo. >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo ## Next Steps >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo 1. Open Claude (https://claude.ai) >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo 2. Load CAVEaT context from prompts >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"
echo 3. Start creating STIX objects! >> "%WORKSPACE_DIR%\QUICK-REFERENCE.md"

echo # Windows Workflow Setup > "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo. >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo ## Next Steps: >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo 1. Open Claude web browser: https://claude.ai >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo 2. Connect GitHub integration (if available) >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo 3. Grant access to your repositories (if you fork them) >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo. >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo ## Loading CAVEaT Context: >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo Please read the CAVEaT prompts from %WORKSPACE_DIR%\CAVEaT\prompts\ >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"
echo Load the framework understanding for creating cloud threat intelligence. >> "%WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md"

echo  [OK] Reference files created
echo.

:: Success message
echo  ===============================================================
echo  =                Installation Complete!                      =
echo  ===============================================================
echo.
echo  [OK] CAVEaT toolkit is now installed and configured!
echo.
echo  [INFO] Installation Location: %INSTALL_DIR%
echo  [INFO] Workspace Location: %WORKSPACE_DIR%
echo.
echo  [>>>] Next Steps:
echo     1. Read your setup instructions in the workspace
echo     2. Open Claude (https://claude.ai)
echo     3. Start creating STIX threat intelligence objects!
echo.
echo  [TIP] Need Help?
echo     * Check: %WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md
echo     * Visit: https://github.com/CloudSecurityAlliance-WG/CAVEaT
echo.
echo  [EMAIL] Questions? Contact the Cloud Security Alliance team
echo.

pause
echo  [>>>] Opening your workspace folder...
start "" "%WORKSPACE_DIR%"

exit /b 0
