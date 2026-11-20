@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter nao encontrado. Adicione o SDK ao PATH.
    pause
    exit /b 1
)

rem Prioridade: argumento, variavel de ambiente, Railway.
set "BUILD_API_URL=%~1"
if not defined BUILD_API_URL set "BUILD_API_URL=%API_BASE_URL%"
if not defined BUILD_API_URL set "BUILD_API_URL=https://tasklab-api.up.railway.app"

echo API do APK: %BUILD_API_URL%
call flutter pub get
if errorlevel 1 (
    echo Nao foi possivel instalar as dependencias.
    pause
    exit /b 1
)

call flutter build apk --release "--dart-define=API_BASE_URL=%BUILD_API_URL%"
set "BUILD_EXIT_CODE=%ERRORLEVEL%"
if "%BUILD_EXIT_CODE%"=="0" (
    echo APK gerado: %~dp0build\app\outputs\flutter-apk\app-release.apk
) else (
    echo Falha ao gerar o APK. Confira a mensagem acima.
)
pause
exit /b %BUILD_EXIT_CODE%
