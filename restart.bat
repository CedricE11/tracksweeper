@echo off
echo ========================================
echo Traccar GPS Tracking System - Restart
echo ========================================
echo.

echo [1/4] Stopping any existing Traccar processes...
taskkill /f /im java.exe 2>nul
echo Waiting for processes to terminate...
timeout /t 3 /nobreak >nul

echo [2/4] Ensuring port 8082 is available...
:check_port
netstat -ano | findstr :8082 >nul
if %errorlevel% equ 0 (
    echo Port 8082 is still in use. Waiting for it to be released...
    timeout /t 2 /nobreak >nul
    goto check_port
)
echo Port 8082 is now available.

echo [3/4] Building frontend...
cd /d "%~dp0traccar-web"
if not exist "package.json" (
    echo ERROR: package.json not found in traccar-web directory!
    echo Current directory: %CD%
    pause
    exit /b 1
)
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Frontend build failed!
    echo Please check for npm errors above.
    pause
    exit /b 1
)
cd /d "%~dp0"

echo [4/4] Starting Traccar server...
echo.
echo ========================================
echo Application will be available at:
echo http://localhost:8082/
echo ========================================
echo.
echo Note: This window will stay open to show the application logs.
echo Press Ctrl+C to stop the application.
echo.
echo Starting server...
echo Waiting for server to start...
start /b java -jar target/tracker-server.jar debug.xml

echo Waiting for server to be ready...
:wait_for_server
timeout /t 1 /nobreak >nul
netstat -ano | findstr :8082 >nul
if %errorlevel% neq 0 (
    echo Still waiting for server to start...
    goto wait_for_server
)

echo.
echo ========================================
echo Server is now running!
echo Application available at: http://localhost:8082/
echo ========================================
echo.
echo Press Ctrl+C to stop the application.
echo.

REM Keep the window open and show server logs
java -jar target/tracker-server.jar debug.xml

echo.
echo Application stopped.
pause


