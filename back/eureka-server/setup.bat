@echo off
REM Reddit Clone - Eureka Server Setup Script for Windows

title Eureka Server Setup

echo.
echo ========================================
echo   Reddit Clone - Eureka Server Setup
echo ========================================
echo.

echo [INFO] Setting up Eureka Server for Windows...
echo.

REM Check Java
echo [CHECK] Checking Java installation...
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java is not installed or not in PATH!
    echo [INFO] Please install Java 17+ from: https://adoptium.net/
    echo [INFO] Make sure to add Java to your PATH
    pause
    exit /b 1
)

java -version 2>&1 | findstr /C:"17\|18\|19\|20\|21" >nul
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Java 17+ is recommended
    echo [INFO] Current Java version:
    java -version
    echo.
)

echo [SUCCESS] Java is available
echo.

REM Check Docker (optional)
echo [CHECK] Checking Docker installation (optional)...
docker --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Docker is available
) else (
    echo [INFO] Docker not found - that's OK, you can run without Docker
    echo [INFO] To use Docker: Install Docker Desktop from docker.com
)
echo.

REM Create necessary directories
echo [INFO] Creating project directories...
if not exist "src\main\java\com\redditclone\eureka" mkdir src\main\java\com\redditclone\eureka
if not exist "src\main\resources" mkdir src\main\resources
if not exist "src\test\java\com\redditclone\eureka" mkdir src\test\java\com\redditclone\eureka
if not exist ".mvn\wrapper" mkdir .mvn\wrapper
if not exist "logs" mkdir logs
echo [SUCCESS] Directories created
echo.

REM Download Maven Wrapper JAR if not exists
echo [INFO] Checking Maven Wrapper...
if not exist ".mvn\wrapper\maven-wrapper.jar" (
    echo [INFO] Downloading Maven Wrapper...
    if exist "mvnw.cmd" (
        mvnw.cmd --version >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo [SUCCESS] Maven Wrapper is ready
        ) else (
            echo [WARNING] Maven Wrapper needs to download dependencies on first run
        )
    )
) else (
    echo [SUCCESS] Maven Wrapper already exists
)
echo.

REM Test basic setup
echo [INFO] Testing basic setup...
if exist "pom.xml" (
    echo [SUCCESS] pom.xml found
) else (
    echo [WARNING] pom.xml not found - make sure to create it
)

if exist "src\main\java\com\redditclone\eureka\EurekaServerApplication.java" (
    echo [SUCCESS] Main application class found
) else (
    echo [WARNING] EurekaServerApplication.java not found - make sure to create it
)

if exist "src\main\resources\application.yml" (
    echo [SUCCESS] Application configuration found
) else (
    echo [WARNING] application.yml not found - make sure to create it
)
echo.

echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Make sure all files are created from the provided templates
echo 2. Run: run.bat start
echo 3. Open browser: http://localhost:8761
echo 4. Login with: admin / admin123
echo.
echo For help: run.bat help
echo.
pause