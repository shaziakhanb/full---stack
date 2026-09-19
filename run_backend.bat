@echo off
cd /d "%~dp0"
echo Starting Darukaa.Earth FastAPI Backend...
.venv\Scripts\python.exe -m uvicorn app.main:app --reload --port 8000
pause
