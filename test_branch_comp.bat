@echo off
echo Starting RISC-V Single Cycle CPU simulation test...

:: Compile all Verilog files
echo Compiling Verilog files...
vlog *.v

:: Run simulation
echo Running simulation...
vsim -c -do "run -all; quit" work.Single_Cycle_Top_Tb

echo Simulation completed. Check the output for Branch_Comp debug information.
pause
