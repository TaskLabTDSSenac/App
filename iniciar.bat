@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter nao encontrado. Adicione o SDK ao PATH.
    pause
    exit /b 1
)

set "APP_DEVICE=%~1"
if not defined APP_DEVICE set "APP_DEVICE=chrome"

call flutter pub get
if errorlevel 1 (
    echo Nao foi possivel instalar as dependencias.
    pause
    exit /b 1
)

echo Mantenha a API ativa na porta 8000.
echo Dispositivo selecionado: %APP_DEVICE%
if /I "%APP_DEVICE%"=="chrome" (
    echo TaskLab Web: http://localhost:5501
    echo A API deve permitir CORS para a porta 5501.
    call flutter run -d chrome --web-port=5501
) else (
    echo O emulador ou dispositivo precisa estar iniciado e conectado.
    echo Consulte o identificador correto com: flutter devices
    call flutter run -d "%APP_DEVICE%"
)
set "APP_EXIT_CODE=%ERRORLEVEL%"
if not "%APP_EXIT_CODE%"=="0" (
    echo Nao foi possivel iniciar. Confira a mensagem acima.
    pause
)
exit /b %APP_EXIT_CODE%
