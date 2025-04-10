@echo off

:: Set color matrix (Green text on black background)
color 0A

:: Display a welcome message with color matrix
echo.
echo ============================
echo  MySQL Database Exporter
echo ============================
echo.

:: Prompt for user input
set /p mysqldump_path="Enter the path to mysqldump.exe (e.g., D:\laragon\bin\mysql\mysql-8.0.30-winx64\bin\mysqldump.exe): "
set /p db_name="Enter the database name: "
set /p user="Enter MySQL username: "
set /p password="Enter MySQL password: "
set /p export_path="Enter the export file path (e.g., C:\Users\User\Desktop\backup.sql): "

:: Display progress with color formatting
echo.
echo Exporting database %db_name%...
echo Please wait...

:: Run mysqldump command with dynamic input
"%mysqldump_path%" -u %user% -p%password% %db_name% > %export_path%

:: Output completion message
echo.
echo Backup completed successfully!
echo The backup file has been saved to: %export_path%
echo.

:: Pause for user to read the output
pause
