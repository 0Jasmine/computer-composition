@echo off
set xv_path=E:\\Xilinx\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto 4f5c4caae4d84403b7bb1515973883fb -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_multiple_behav xil_defaultlib.tb_multiple xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
