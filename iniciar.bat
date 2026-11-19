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
set "APP_WEB_PORT=%~2"
if not defined APP_WEB_PORT (
    for /f %%P in ('powershell -NoProfile -Command "$used = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners().Port; $port = 5501; while ($used -contains $port) { $port++ }; $port"') do set "APP_WEB_PORT=%%P"
)
if not defined APP_WEB_PORT (
    echo Nao foi possivel selecionar uma porta para o Flutter Web.
    pause
    exit /b 1
)

call flutter pub get
if errorlevel 1 (
    echo Nao foi possivel instalar as dependencias.
    pause
    exit /b 1
)

echo Mantenha a API ativa na porta 8000.
echo Dispositivo selecionado: %APP_DEVICE%
if /I "%APP_DEVICE%"=="chrome" (
    echo TaskLab Web: http://localhost:%APP_WEB_PORT%
    echo A API deve permitir CORS para a porta %APP_WEB_PORT%.
    if not "%APP_WEB_PORT%"=="5501" echo A porta 5501 estava ocupada; foi selecionada uma porta livre.
    call flutter run -d chrome --web-port=%APP_WEB_PORT%
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
