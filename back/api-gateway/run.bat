@echo off
REM Reddit Clone - API Gateway Windows Script

title Reddit Clone - API Gateway

echo.
echo ========================================
echo   Reddit Clone - API Gateway
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
if "%1"=="routes" goto routes
if "%1"=="help" goto help
goto help

:start
echo [INFO] Starting API Gateway locally...
echo [INFO] Building and running with Maven...
echo.
echo [WARN] Make sure Redis is running on localhost:6379
echo [WARN] Make sure Eureka Server is running on localhost:8761
echo.
mvnw.cmd spring-boot:run
goto end

:docker
echo [INFO] Starting with Docker...
echo [INFO] Building and running containers...
echo.
echo [INFO] Creating network if not exists...
docker network create reddit-network 2>nul
echo [INFO] Starting services...
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
echo [INFO] Cleaning Docker volumes...
docker volume prune -f
echo [SUCCESS] Cleanup completed!
goto end

:health
echo [INFO] Checking API Gateway health...
echo.
curl -f http://localhost:8080/actuator/health
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [SUCCESS] API Gateway is running and healthy!
    echo [INFO] Gateway: http://localhost:8080
    echo [INFO] Health: http://localhost:8080/actuator/health
    echo [INFO] Metrics: http://localhost:8080/actuator/prometheus
    echo [INFO] Routes: http://localhost:8080/actuator/gateway/routes
) else (
    echo.
    echo [ERROR] API Gateway is not responding!
    echo [INFO] Make sure the gateway is running with: run.bat start
)
goto end

:routes
echo [INFO] Checking Gateway Routes...
echo.
curl -s http://localhost:8080/actuator/gateway/routes | jq .
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] jq not found, showing raw response:
    curl -s http://localhost:8080/actuator/gateway/routes
)
goto end

:help
echo Usage: run.bat [command]
echo.
echo Available commands:
echo   start   - Start API Gateway locally (default)
echo   docker  - Start with Docker Compose
echo   build   - Build the application
echo   test    - Run all tests
echo   clean   - Clean build files and stop containers
echo   health  - Check if gateway is running
echo   routes  - Show configured routes
echo   help    - Show this help message
echo.
echo Examples:
echo   run.bat              (starts gateway)
echo   run.bat start        (starts gateway)
echo   run.bat docker       (starts with Docker)
echo   run.bat health       (checks health)
echo   run.bat routes       (shows routes)
echo.
echo Prerequisites:
echo   - Eureka Server running on localhost:8761
echo   - Redis running on localhost:6379 (for rate limiting)
echo.
echo After starting, access:
echo   Gateway:   http://localhost:8080
echo   Health:    http://localhost:8080/actuator/health
echo   Metrics:   http://localhost:8080/actuator/prometheus
echo   Routes:    http://localhost:8080/actuator/gateway/routes
echo.
goto end

:end
echo.
pause