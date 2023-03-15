@echo off
set xv_path=E:\\Xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto 029bafc1988d4b76ada9cd7c136b3c7d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_adder32_behav xil_defaultlib.tb_adder32 xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
