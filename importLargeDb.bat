@echo off
title MySQL Large Database Import Tool - by sumonta121@gmail.com
color 0A
setlocal enabledelayedexpansion

echo ====================================================
echo         MySQL Import Tool for Windows (Laragon)
echo ====================================================
echo   Author: sumonta121@gmail.com
echo ----------------------------------------------------
echo.


set /p MYSQL_BIN=🔧 Enter full path to MySQL binary [e.g., D:\laragon\bin\mysql\mysql-8.0.30\bin\mysql.exe]: 
if not exist "%MYSQL_BIN%" (
    echo ❌ MySQL binary not found at: %MYSQL_BIN%
    pause
    exit /b
)


set /p DB_NAME=🧠 Enter the name of the database to import to: 


set /p DB_USER=👤 Enter MySQL username (default: root): 
if "%DB_USER%"=="" set DB_USER=root


set /p DB_PASS=🔐 Enter MySQL password (leave blank if none): 


set /p SQL_FILE=📄 Enter full path to the .sql file: 
if not exist "%SQL_FILE%" (
    echo ❌ SQL file not found at: %SQL_FILE%
    pause
    exit /b
)


echo.
echo ========= ✅ Please Confirm =========
echo MySQL Path : %MYSQL_BIN%
echo Database   : %DB_NAME%
echo Username   : %DB_USER%
echo SQL File   : %SQL_FILE%
echo =====================================
echo.
set /p CONFIRM=Proceed with import? (Y/N): 
if /i "%CONFIRM%" NEQ "Y" (
    echo ❌ Cancelled by user.
    pause
    exit /b
)


echo 🛠️  Creating database if it doesn't exist...
if "%DB_PASS%"=="" (
    "%MYSQL_BIN%" -u %DB_USER% -e "CREATE DATABASE IF NOT EXISTS `%DB_NAME%`;"
) else (
    "%MYSQL_BIN%" -u %DB_USER% -p%DB_PASS% -e "CREATE DATABASE IF NOT EXISTS `%DB_NAME%`;"
)


cls
echo.
echo ⏳ Importing database... Please wait...
echo.

set "charset=01"
set "spinner=|/-\"


(
    if "%DB_PASS%"=="" (
        "%MYSQL_BIN%" -u %DB_USER% %DB_NAME% < "%SQL_FILE%"
    ) else (
        "%MYSQL_BIN%" -u %DB_USER% -p%DB_PASS% %DB_NAME% < "%SQL_FILE%"
    )
) > nul 2>&1


for /L %%A in (1,1,20) do (
    set "line="
    for /L %%B in (1,1,40) do (
        set /A rand=!random! %% 2
        set "line=!line!!rand!"
    )
    echo !line!
    timeout /nobreak /t 1 >nul
)


cls
if %ERRORLEVEL%==0 (
    echo ✅ Database import completed successfully!
    echo 💡 You can now view it in phpMyAdmin (http://localhost/phpmyadmin)
) else (
    echo ❌ Import failed. Please check the SQL file, credentials, or database name.
)

echo.
pause
exit /b
