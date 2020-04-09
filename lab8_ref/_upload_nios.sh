# Joseph Ravichandran 
# Last edited on 5/18/19

# This is the .elf file associated with the Nios (in your software directory)
# Change me to whatever elf you want!
NIOS_ELF=".\\software\\usb_kb\\usb_kb.elf"

# Ensure the ELF actually exists
if [ -f $NIOS_ELF ];
then
	echo "Found ELF File, Uploading..."
else
	echo "ELF File does not exist, please check your NIOS_ELF variable in '_upload_nios.sh'"
	exit
fi

# Upload the ELF
"$SOPC_KIT_NIOS2/nios2_command_shell.sh" nios2-download $NIOS_ELF -c USB-Blaster[USB-0] -r -g

# Connect to interactive terminal
"$SOPC_KIT_NIOS2/nios2_command_shell.sh" nios2-terminal -c USB-Blaster[USB-0]

# Exit the Cygwin environment
exit
