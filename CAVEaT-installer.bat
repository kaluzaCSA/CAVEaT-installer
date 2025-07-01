@echo off
setlocal EnableDelayedExpansion

:: CAVEaT Toolkit Installer for Windows
:: Cloud Adversarial Vectors, Exploits, and Threats Setup
:: Version 1.0

echo.
echo  ===============================================================
echo  =                Installation Complete!                      =
echo  ===============================================================
echo.
echo  🔧 Setting up your CAVEaT development environment...
echo.

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  ❌ This installer requires administrator privileges.
    echo  📝 Please right-click and "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo  ✅ Administrator privileges confirmed
echo.

:: Set installation directory - use a different name to avoid conflicts
set INSTALL_DIR=%USERPROFILE%\caveat-installation
echo  📁 Creating installation directory: %INSTALL_DIR%

:: Only clean up if user explicitly agrees
if exist "%INSTALL_DIR%" (
    echo  ⚠️  Installation directory already exists.
    choice /M "Do you want to clean it up and start fresh"
    if !errorlevel! equ 1 (
        echo  🧹 Cleaning up existing installation...
        rmdir /s /q "%INSTALL_DIR%" 2>nul
    ) else (
        echo  📂 Using existing directory...
    )
)

if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if %errorlevel% neq 0 (
        echo  ❌ Failed to create installation directory
        pause
        exit /b 1
    )
)

cd /d "%INSTALL_DIR%"
echo  ✅ Installation directory ready
echo.

:: Check for Git
echo  🔍 Checking for Git...
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  📦 Installing Git...
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  ❌ Failed to install Git
        echo  📝 Please install Git manually from: https://git-scm.com/
        pause
        exit /b 1
    )
    echo  ✅ Git installed successfully
    echo  🔄 Please restart your command prompt and run this installer again
    pause
    exit /b 0
) else (
    echo  ✅ Git is already installed
)
echo.

:: Check for Node.js
echo  🔍 Checking for Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  📦 Installing Node.js...
    winget install OpenJS.NodeJS --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  ❌ Failed to install Node.js
        echo  📝 Please install Node.js manually from: https://nodejs.org/
        pause
        exit /b 1
    )
    echo  ✅ Node.js installed successfully
    echo  🔄 Please restart your command prompt and run this installer again
    pause
    exit /b 0
) else (
    echo  ✅ Node.js is already installed
)
echo.

:: Check for GitHub CLI
echo  🔍 Checking for GitHub CLI...
gh --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  📦 Installing GitHub CLI...
    winget install GitHub.cli --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo  ❌ Failed to install GitHub CLI
        echo  📝 Please install GitHub CLI manually
        pause
        exit /b 1
    )
    echo  ✅ GitHub CLI installed successfully
) else (
    echo  ✅ GitHub CLI is already installed
)
echo.

:: Clone the CAVEaT repository
echo  📡 Downloading CAVEaT repository...
if not exist "CAVEaT" (
    git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git CAVEaT 2>nul
    if %errorlevel% neq 0 (
        echo  ❌ Failed to download CAVEaT repository
        echo  📝 Please check your internet connection and try again
        pause
        exit /b 1
    )
    echo  ✅ CAVEaT repository downloaded successfully
) else (
    echo  ✅ CAVEaT repository already exists
)
echo.

:: Create workspace directory
set WORKSPACE_DIR=%USERPROFILE%\caveat-workspace
echo  📁 Creating workspace directory: %WORKSPACE_DIR%

if not exist "%WORKSPACE_DIR%" (
    mkdir "%WORKSPACE_DIR%" 2>nul
)

cd /d "%WORKSPACE_DIR%"

:: Clone repositories to workspace
echo  📡 Setting up workspace repositories...

if not exist "CAVEaT" (
    git clone https://github.com/CloudSecurityAlliance-WG/CAVEaT.git CAVEaT 2>nul
    if %errorlevel% neq 0 (
        echo  ⚠️  Could not clone CAVEaT to workspace
    ) else (
        echo  ✅ CAVEaT cloned to workspace
    )
)

if not exist "cti" (
    git clone https://github.com/CloudSecurityAlliance/cti.git cti 2>nul
    if %errorlevel% neq 0 (
        echo  ⚠️  Could not clone CTI repository
        echo  💡 You can manually clone it later if needed
    ) else (
        echo  ✅ CTI repository cloned to workspace
    )
)

:: GitHub authentication and forking
echo.
echo  🔐 Setting up GitHub authentication...
echo  💡 You can fork repositories later for contributing
echo.

gh auth status >nul 2>&1
if %errorlevel% neq 0 (
    echo  🔑 GitHub authentication required for forking repositories
    choice /M "Do you want to authenticate with GitHub now"
    if !errorlevel! equ 1 (
        gh auth login
        if %errorlevel% equ 0 (
            echo  ✅ GitHub authentication successful
            echo.
            choice /M "Do you want to fork the repositories to your GitHub account"
            if !errorlevel! equ 1 (
                echo  🍴 Forking CAVEaT repository...
                gh repo fork CloudSecurityAlliance-WG/CAVEaT --clone=false 2>nul
                echo  🍴 Forking CTI repository...
                gh repo fork CloudSecurityAlliance/cti --clone=false 2>nul
                echo  ✅ Repositories forked successfully
            )
        ) else (
            echo  ⚠️  GitHub authentication failed
            echo  💡 You can authenticate later with: gh auth login
        )
    )
) else (
    echo  ✅ Already authenticated with GitHub
)

:: Create reference files
echo.
echo  📄 Creating reference files...

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

echo  ✅ Reference files created
echo.

:: Success message
echo  ╔═══════════════════════════════════════════════════════════════╗
echo  ║                    🎉 Installation Complete! 🎉               ║
echo  ╚═══════════════════════════════════════════════════════════════╝
echo.
echo  ✅ CAVEaT toolkit is now installed and configured!
echo.
echo  📍 Installation Location: %INSTALL_DIR%
echo  📍 Workspace Location: %WORKSPACE_DIR%
echo.
echo  🚀 Next Steps:
echo     1. Read your setup instructions in the workspace
echo     2. Open Claude (https://claude.ai)
echo     3. Start creating STIX threat intelligence objects!
echo.
echo  💡 Need Help?
echo     • Check: %WORKSPACE_DIR%\SETUP-INSTRUCTIONS.md
echo     • Visit: https://github.com/CloudSecurityAlliance-WG/CAVEaT
echo.
echo  📧 Questions? Contact the Cloud Security Alliance team
echo.

pause
echo  🎯 Opening your workspace folder...
start "" "%WORKSPACE_DIR%"

exit /b 0
