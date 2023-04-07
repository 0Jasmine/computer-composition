@echo off
set xv_path=E:\\Xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xsim tb_multiple_behav -key {Behavioral:sim_1:Functional:tb_multiple} -tclbatch tb_multiple.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
