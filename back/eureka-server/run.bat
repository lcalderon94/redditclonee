@echo off
REM Reddit Clone - Eureka Server Windows Script

title Reddit Clone - Eureka Server

echo.
echo ========================================
echo   Reddit Clone - Eureka Server
echo ========================================
echo.

if "%1"=="" goto start
if "%1"=="start" goto start
if "%1"=="run" goto start
if "%1"=="docker" goto docker
if "%1"=="build" goto build
if "%1"=="test" goto test
if "%1"=="clean" goto clean
if "%1"=="health" goto health
if "%1"=="help" goto help
goto help

:start
echo [INFO] Starting Eureka Server locally...
echo [INFO] Building and running with Maven...
echo.
mvnw.cmd spring-boot:run
goto end

:docker
echo [INFO] Starting with Docker...
echo [INFO] Building and running containers...
echo.
docker-compose up --build
goto end

:build
echo [INFO] Building application...
echo.
mvnw.cmd clean package
echo.
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Build completed successfully!
) else (
    echo [ERROR] Build failed!
)
goto end

:test
echo [INFO] Running tests...
echo.
mvnw.cmd test
echo.
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] All tests passed!
) else (
    echo [ERROR] Some tests failed!
)
goto end

:clean
echo [INFO] Cleaning up...
echo [INFO] Cleaning Maven build...
mvnw.cmd clean
echo [INFO] Stopping Docker containers...
docker-compose down
echo [SUCCESS] Cleanup completed!
goto end

:health
echo [INFO] Checking Eureka Server health...
echo.
curl -f http://localhost:8761/actuator/health
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] Eureka Server is running and healthy!
    echo [INFO] Dashboard: http://localhost:8761
    echo [INFO] Credentials: admin / admin123
) else (
    echo.
    echo [ERROR] Eureka Server is not responding!
    echo [INFO] Make sure the server is running with: run.bat start
)
goto end

:help
echo Usage: run.bat [command]
echo.
echo Available commands:
echo   start   - Start Eureka Server locally (default)
echo   docker  - Start with Docker Compose
echo   build   - Build the application
echo   test    - Run all tests
echo   clean   - Clean build files and stop containers
echo   health  - Check if server is running
echo   help    - Show this help message
echo.
echo Examples:
echo   run.bat              (starts server)
echo   run.bat start        (starts server)
echo   run.bat docker       (starts with Docker)
echo   run.bat health       (checks health)
echo.
echo After starting, access:
echo   Dashboard: http://localhost:8761
echo   Health:    http://localhost:8761/actuator/health
echo   Login:     admin / admin123
echo.
goto end

:end
echo.
pause