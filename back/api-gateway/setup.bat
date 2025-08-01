@echo off
REM Reddit Clone - API Gateway Setup Script for Windows

title API Gateway Setup

echo.
echo ========================================
echo   Reddit Clone - API Gateway Setup
echo ========================================
echo.

echo [INFO] Setting up API Gateway for Windows...
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

REM Check Redis
echo [CHECK] Checking Redis availability...
redis-cli ping >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Redis is running
) else (
    echo [WARNING] Redis not found or not running
    echo [INFO] Redis is required for rate limiting
    echo [INFO] Install Redis from: https://redis.io/download
    echo [INFO] Or use Docker: docker run -d -p 6379:6379 redis:7-alpine
)
echo.

REM Check Eureka Server
echo [CHECK] Checking Eureka Server...
curl -f http://localhost:8761/actuator/health >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Eureka Server is running
) else (
    echo [WARNING] Eureka Server not found or not running
    echo [INFO] Eureka Server is required for service discovery
    echo [INFO] Start Eureka Server first: cd ../eureka-server && run.bat start
)
echo.

REM Check Docker (optional)
echo [CHECK] Checking Docker installation (optional)...
docker --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Docker is available
    docker network ls | findstr reddit-network >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [INFO] Creating Docker network...
        docker network create reddit-network
        echo [SUCCESS] Docker network created
    ) else (
        echo [SUCCESS] Docker network already exists
    )
) else (
    echo [INFO] Docker not found - that's OK, you can run without Docker
    echo [INFO] To use Docker: Install Docker Desktop from docker.com
)
echo.

REM Create necessary directories
echo [INFO] Creating project directories...
if not exist "src\main\java\com\redditclone\gateway\config" mkdir src\main\java\com\redditclone\gateway\config
if not exist "src\main\java\com\redditclone\gateway\filter" mkdir src\main\java\com\redditclone\gateway\filter
if not exist "src\main\java\com\redditclone\gateway\exception" mkdir src\main\java\com\redditclone\gateway\exception
if not exist "src\main\resources" mkdir src\main\resources
if not exist "src\test\java\com\redditclone\gateway" mkdir src\test\java\com\redditclone\gateway
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

if exist "src\main\java\com\redditclone\gateway\ApiGatewayApplication.java" (
    echo [SUCCESS] Main application class found
) else (
    echo [WARNING] ApiGatewayApplication.java not found - make sure to create it
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
echo Prerequisites Check:
echo   ✅ Java 17+ installed
if exist "redis-cli.exe" (
    echo   ✅ Redis available
) else (
    echo   ⚠️  Redis recommended for rate limiting
)
curl -f http://localhost:8761/actuator/health >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo   ✅ Eureka Server running
) else (
    echo   ⚠️  Eureka Server required
)
echo.
echo Next steps:
echo 1. Make sure all files are created from the provided templates
echo 2. Start Eureka Server: cd ../eureka-server && run.bat start
echo 3. Start Redis: docker run -d -p 6379:6379 redis:7-alpine
echo 4. Run: run.bat start
echo 5. Test: http://localhost:8080/actuator/health
echo.
echo For help: run.bat help
echo.
pause