@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
    echo Flutter nao encontrado. Adicione o SDK ao PATH.
    goto erro
)
call flutter pub get
if errorlevel 1 goto erro
echo TaskLab Mobile Web: http://localhost:5501
echo A API precisa estar ativa na porta 8000 e permitir CORS para 5501.
call flutter run -d chrome --web-port=5501
if errorlevel 1 goto erro
exit /b 0
:erro
echo Nao foi possivel iniciar. Confira a mensagem acima.
pause
exit /b 1
