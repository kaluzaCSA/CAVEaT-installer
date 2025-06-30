@echo off
setlocal EnableDelayedExpansion

:: CAVEaT Toolkit Installer
:: Cloud Adversarial Vectors, Exploits, and Threats Setup
:: Version 1.0

echo.
echo  ╔═══════════════════════════════════════════════════════════════╗
echo  ║                    CAVEaT Toolkit Installer                   ║
echo  ║           Cloud Security Alliance Development Setup           ║
echo  ║                         Version 1.0                          ║
echo  ╚═══════════════════════════════════════════════════════════════╝
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

:: Create installation directory
set INSTALL_DIR=%USERPROFILE%\caveat-toolkit
echo  📁 Creating installation directory: %INSTALL_DIR%

if exist "%INSTALL_DIR%" (
    echo ⚠️  Directory already exists. Cleaning up...
    rmdir /s /q "%INSTALL_DIR%" 2>nul
)

mkdir "%INSTALL_DIR%" 2>nul
if %errorlevel% neq 0 (
    echo  ❌ Failed to create installation directory
    pause
    exit /b 1
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
) else (
    echo  ✅ Git is already installed
)
echo.

:: Check for Node.js
echo  🔍 Checking for Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  📦 Installing Node.js...
    winget install OpenJS.NodeJS --ac