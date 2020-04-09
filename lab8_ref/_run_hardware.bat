@ rem Joseph Ravichandran 5/10/19
@ rem This program will detect the presence of a JTAG cable, and attempt to upload the .sof file associated with the project
@ rem This program assumes that environment variables SOPC_KIT_NIOS2, QUARTUS_ROOTDIR, SOPC_BUILDER_PATH are set

@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ rem This is the Quartus .sof file (relative path to script directory) to initialize with:
@ rem Change me to upload a different sof file!
set QUARTUS_SOF=".\lab8.sof"

@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64

@ rem Quit the program if the Quartus sof file does not exist
@ if not exist %QUARTUS_SOF% (
	echo "SOF File not found. Check the QUARTUS_SOF variable in '_run_hardware.bat'"
	pause
	exit
)

@rem Check the status of the cable:
%QUARTUS_BIN%\\quartus_pgm.exe -c USB-Blaster[USB-0] -a

@rem Attempt to upload the sof file from output_files (default quartus build location)
%QUARTUS_BIN%\\quartus_pgm.exe -m jtag -c USB-Blaster[USB-0] -o "p;%QUARTUS_SOF%"

pause