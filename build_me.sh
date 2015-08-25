#!/bin/bash

# Let me introduce myself...

echo "-----------------------------------------------------------------------------"
echo "HELLO WORLD!"
echo " - I'm Zamajalo's automated kernel building script"
echo " - For all of you who hate setting shell variables over and over and over..."
echo " - Just make sure you've already set variable names here before you continue!"
echo " - Good luck!"
echo "*** BYE WORLD ***"
echo "-----------------------------------------------------------------------------"
echo " "

# ARCH LINUX USERS ONLY!
# We need to initialise python2 as python, instead of pyhon3 which is default.
# So, if you have configured your android building env as described in arch wiki
# (or if you haven't, please do: https://wiki.archlinux.org/index.php/Android#Building_Android)
# YOU NEED THIS LINE.
# Other distros... well, I don't know. I have Mint 17.1 and I'm too lazy to reboot and test.
source "/media/data/py27_venv/bin/activate"

toolchains_dir="/media/data/toolchains" 	# Folder where you keep your toolchains
toolchain_name="linaro_a15_484-2014.11"		# toolchain's folder name - if your toolchain is in
											# /home/javert_your_eyes/android/toolchains/ImAToolchain_aX_YZW
											# you put ImAToolchain_aX_YZW here.

# Generate full toolchain path
toolchain_path="$toolchains_dir/$toolchain_name/bin/arm-cortex_a15-linux-gnueabihf-"	# There is really no need for you
																						# to touch this, only if symlinks/names
																						# in toolchain's folder are not given like that.
echo " + Toolchain path set to $toolchain_path"

# Set needed variables for kernel build
export CROSS_COMPILE=$toolchain_path		# You don't wanna mess with this variable.
echo " + CROSS_COMPILE variable set"

# Set architecture
export ARCH="arm"							# I'm 99% sure you won't need to change this. Only if someday you make a x86 android build

# Set defconfig to build
defconfig="zeKrnl_e980_defconfig"		# Configure this! This is a defconfig file for your device
											# If not found, first make will just fail to interactive kernel config
											# and you're in a deep sheet.
echo " + defconfig variable set to $defconfig"

# Set number of threads/cores. If you have 4 cores, set it to 4+1=5.
# General rule: n cores => value is n+1.
CORES=1

# Echo command line... AND PLEASE; DON'T EDIT NOTHING BELOW THIS COMMENT BLOCK
# YOUR KITTY MAY GO TO THE DARK SIDE IF YOU DO

# Build function. Yes I'm a procedural biatch.
function start_building_NOW {
	echo "--------------------------------------------------------"
	echo " "
	# Start making kernel
	# Check if .config exist...
	echo " -> Checking if .config exists..."
	if [ ! -f "$PWD/.config" ]; then
		echo " --> Kernel configuration not found. Making one from defconfig..."
		make $defconfig;
	else
		echo "--> Kernel configuration found. Do you want to reuse it or write new?"
		select ans in "New" "Reuse"; do
			case $ans in
				New )
					echo " ---> Making new configuration...";
					make $defconfig;
					break;;
				Reuse )
					echo " --> OK, ready for the next step.";
					break;;
			esac
		done
	fi
	
	# Ask user if he/she wants to make some changes to .config
	echo " --> Done. Do you want to make some changes to the kernel config?"
	select yn in "y" "n"; do
		case $yn in
			y ) 
				echo "---> Running make menuconfig. Don't forget to save!";
				echo " ";
				make menuconfig;
				break;;
			n ) 
				echo " --> OK, continuing with build..."
				break;;
		esac
	done
	echo " -> Ready to start building... Press any key to start."
	read blah
	echo " "				
	make -j$CORES;
}

# Main code.
echo "******************************************************************"
echo "******************* READY TO RUMBLE! *****************************"
echo "******************************************************************"
echo "=> Build command line:"
echo -e "CROSS_COMPILE=$CROSS_COMPILE\nARCH=$ARCH\nmake $defconfig"

# Confirm build start
echo "==> Is previous line correct? (select number please)"
select yn in "y" "n"; do
    case $yn in
        y )
			echo "=> You said yes. OK, build is starting. Fingers-crossed!"
			start_building_NOW;
			break;;
        n ) 
			echo "=> You said no. Please review data inserted into this file."
			exit;;
    esac
done
