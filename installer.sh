#!/bin/bash
CONFIG="/boot/config.txt"
REVCODE=$(sudo cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^ *//g' | sed 's/ *$//g')
if [ "$REVCODE" = "90092" ] || [ "$REVCODE" = "90093" ] || [ "$REVCODE" = "0x9000C1" ];
then
    echo "Raspberry Pi Zero"
    if grep -Fq "arm_freq" $CONFIG
    then
	echo "Modifying arm_freq"
	sed -i "/arm_freq/c\arm_freq=1100" $CONFIG
    else
	echo "arm_freq not defined. Creating definition"
	echo "arm_freq=1100" >> $CONFIG
    fi
fi
if [ "$REVCODE" = "a02082" ] || [ "$REVCODE" = "a22082" ];
then
    echo "Raspberry Pi 3"
    if grep -Fq "arm_freq" $CONFIG
    then
	echo "Modifying arm_freq"
	sed -i "/arm_freq/c\arm_freq=1300" $CONFIG
    else
	echo "arm_freq not defined. Creating definition"
	echo "arm_freq=1300" >> $CONFIG
    fi
fi
if grep -Fq "gpu_freq" $CONFIG
then
	echo "Modifying gpu_freq"
	sed -i "/gpu_freq/c\gpu_freq=500" $CONFIG
else
	echo "gpu_freq not defined. Creating definition"
	echo "gpu_freq=500" >> $CONFIG
fi
if grep -Fq "gpu_mem" $CONFIG
then
	echo "Modifying gpu_mem"
	sed -i "/gpu_mem/c\gpu_mem=128" $CONFIG
else
	echo "gpu_mem not defined. Creating definition"
	echo "gpu_mem=128" >> $CONFIG
fi
if grep -Fq "core_freq" $CONFIG
then
	echo "Modifying core_freq"
	sed -i "/core_freq/c\core_freq=500" $CONFIG
else
	echo "core_freq not defined. Creating definition"
	echo "core_freq=500" >> $CONFIG
fi
if grep -Fq "sdram_freq" $CONFIG
then
	echo "Modifying sdram_freq"
	sed -i "/sdram_freq/c\sdram_freq=500" $CONFIG
else
	echo "sdram_freq not defined. Creating definition"
	echo "sdram_freq=500" >> $CONFIG
fi
if grep -Fq "sdram_schmoo" $CONFIG
then
	echo "Modifying sdram_schmoo"
	sed -i "/sdram_schmoo/c\sdram_schmoo=0x02000020" $CONFIG
else
	echo "sdram_schmoo not defined. Creating definition"
	echo "sdram_schmoo=0x02000020" >> $CONFIG
fi
if grep -Fq "over_voltage" $CONFIG
then
	echo "Modifying over_voltage amd sdram_over_voltage"
	sed -i "/over_voltage/d" $CONFIG
	echo "over_voltage=5" >> $CONFIG
	echo "sdram_over_voltage=2" >> $CONFIG
else
	echo "over_voltage not defined. Creating definition"
	echo "over_voltage=5" >> $CONFIG
	echo "sdram_over_voltage not defined. Creating definition"
	echo "sdram_over_voltage=2" >> $CONFIG
fi
if grep -Fq "dtparam=sd_overclock" $CONFIG
then
	echo "Modifying dtparam=sd_overclock"
	sed -i "/dtparam=sd_overclock/c\dtparam=sd_overclock=100" $CONFIG
else
	echo "dtparam=sd_overclock not defined. Creating definition"
	echo "dtparam=sd_overclock=100" >> $CONFIG
fi
if grep -Fq "force_turbo=1" $CONFIG
then
	echo "CPU Turbo already enabled"
else
	echo "Force Turbo on CPU?"
	echo "THIS VOIDS THE WARRANTY on your $10-35 investment."
	echo "MUST have a heatsink for this one!"
	echo -n "set 'force_turbo=1'? (y/n)? "
	read answer
	if echo "$answer" | grep -iq "^y" ;
	then
		echo "force_turbo=1" >> $CONFIG
		echo "boot_delay=1" >> $CONFIG
	else
		echo "CPU Turbo NOT enabled at this time"
	fi
fi
echo "Overclock settings updated."
echo -n "Reboot Now? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;
then
    echo "rebooting down..."
    sudo reboot now
else
    echo "Done."
fi
