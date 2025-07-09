@echo off
echo Testing Branch_Comp module...

:: Compile Branch_Comp and testbench
echo Compiling Branch_Comp module...
vlog Branch_Comp.v Branch_Comp_Test_tb.v

:: Run simulation
echo Running Branch_Comp test...
vsim -c -do "run -all; quit" work.Branch_Comp_Test_Tb

echo Branch_Comp test completed.
pause
