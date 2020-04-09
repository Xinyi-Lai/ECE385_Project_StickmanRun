@ rem Joseph Ravichandran 5/10/19
@ rem This program will detect the presence of a JTAG cable, and attempt to upload a NIOS ELF to the hardware
@ rem It will then proceed to attempt to connect to a terminal session with the NIOS
@ rem This program assumes that environment variables SOPC_KIT_NIOS2, QUARTUS_ROOTDIR, SOPC_BUILDER_PATH are set
@ rem It also assumes the presence of the file '_upload_nios.sh'

@ rem To change which ELF file is uploaded, please see _upload_nios.sh

@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ REM ######################################
@ REM # Variable to ignore mixed paths
@ REM # i.e. G:/$SOPC_KIT_NIOS2/bin
@ set CYGWIN=nodosfilewarning

@ set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin
@ if not exist "%QUARTUS_BIN%" set QUARTUS_BIN=%QUARTUS_ROOTDIR%\bin64

@rem Check the status of the cable:
%QUARTUS_BIN%\\quartus_pgm.exe -c USB-Blaster[USB-0] -a

@rem Launch the nios Cygwin and run upload_nios shell script
@ set SOPC_BUILDER_PATH=%SOPC_KIT_NIOS2%+%SOPC_BUILDER_PATH%
@ "%QUARTUS_BIN%\\cygwin\bin\bash.exe" --rcfile ".\_upload_nios.sh"

pause