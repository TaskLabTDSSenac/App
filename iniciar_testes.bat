@echo off
setlocal
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter nao encontrado no PATH. Configure o SDK e reabra o terminal.
    goto erro
)
if "%~1"=="" (
    echo Informe o identificador do emulador Android como primeiro argumento.
    echo Consulte os dispositivos com: flutter devices
    echo Uso: iniciar_testes.bat ID_DO_DISPOSITIVO [URL_DA_API]
    echo URL padrao: http://10.0.2.2:8000
    goto erro
)
set "TEST_DEVICE=%~1"
set "TEST_API_URL=%~2"
if not defined TEST_API_URL set "TEST_API_URL=http://10.0.2.2:8000"

call flutter pub get
if errorlevel 1 goto erro

echo Inicie manualmente a API de testes e o emulador Android.
echo O teste remove apenas a sessao salva do TaskLab e pode cadastrar uma conta.
call flutter test integration_test -d "%TEST_DEVICE%" "--dart-define=API_BASE_URL=%TEST_API_URL%"
set "TEST_EXIT_CODE=%ERRORLEVEL%"
echo.
echo Codigo de saida do teste: %TEST_EXIT_CODE%
pause
exit /b %TEST_EXIT_CODE%

:erro
pause
exit /b 1
