@echo off
echo ====================================
echo   Pipeline RISC-V Simulation
echo ====================================

echo.
echo [1] Compiling Verilog files...
iverilog -o pipeline_sim *.v

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo [2] Running simulation...
vvp pipeline_sim

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Simulation failed!
    pause
    exit /b 1
)

echo.
echo [3] Simulation completed successfully!
echo Generated files:
echo   - pipeline_tb.vcd (waveform file)

echo.
echo To view waveform, run: gtkwave pipeline_tb.vcd
echo.
pause
