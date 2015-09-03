#!/bin/bash

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

## Let me introduce myself...

echo ">>>>> zeKrnl build script for LG Optimus G Pro E98x"
echo ">>>>> Based on work from zamajalo@xda, with my modifications and additions"
echo ">>>>> Licenced as GPL, so you can share & edit, just don't make it forget who original author is"
echo " "
echo " "

## Configuration part

# For Arch linux users (I don't know if anyone else has this problem)
# Our precious distro uses python3 as default, but for successful Android building we need python2.7
# Since we don't have a function like set-defaults on Ubuntu/Mint, we have to do it the old way.
# Make sure you have instaled everything described here:
# ++++ https://wiki.archlinux.org/index.php/Android#Building_Android
# 
# This version of script will check do you have python27 virtual env, activate if you have it, and install if you don't.
# Only two things this script needs are
# a) proper installation of build-tools, as described on link above
# b) a path where you installed/want to install python27 virtual env.

venv_path="/media/data/py27_venv/"

# Now we need some informations about your toolchain.
# Legend:
# - toolchains_dir -> location where toolchains are located
# - toolchain_name -> name of the directory toolchain is located

toolchains_dir="/media/data/toolchains"
toolchain_name="linaro_a15_484-2014.11"

# Now, name of the configuration file...
defconfig_name="cyanogenmod_e980_defconfig"

# Set number of threads/cores. If you have 4 cores, set it to 4+1=5.
# General rule: n cores => value is n+1. Set it to 1 if you want to watch line by line and hunt for errors
jobs=1

# Name of example boot.img to use for boot.img regeneration
template_bootimg="boot-pac-kk.img"

# And finaly, information about architecture you're building for. 
# OFC, if you're using this for OGPro, you gonna need arm...
device_arch="arm"

## It's fun time! Don't edit this if you really don't have a need for that.

function createVenv {
	pyvenv --system-site-packages --copies "$venv_path"
}

### Check if you're running Arch
echo "-> Checking if running on Arch Linux..."

distro=`cat /etc/os-release | grep ID |  cut -d'=' -f 2`

if [ "$distro" == "arch" ]; then
	echo "+ Running on Arch Linux"
	if [ -d "$venv_path" ]; then
		echo "++ python27 virtual env. installed in $venv_path, activating"
		source "$venv_path/bin/activate"
	else
		echo "++ python27 virtual env. not found, checking if installer is present..."
		if [ hash pyvenv 2>/dev/null ]; then
			echo "+++ pyvenv available, installing..."
			createVenv
		else
			echo "+++ pyvenv binary not found, aborting..."
			exit
		fi
	fi
fi

echo " "

### Check for toolchains
echo "-> Checking if toolchain is installed..."

toolchain_path="$toolchains_dir/$toolchain_name/bin/arm-cortex_a15-linux-gnueabihf-"
if [ -d "$toolchains_dir/$toolchain_name/bin/" ]; then
	echo "+ Toolchain path set to $toolchain_path"
else
	echo "+ Toolchain not found on $toolchain_path, aborting..."
	exit
fi

### We're alive, let's create needed variables
echo " "
echo "-> Setting variables:"
export CROSS_COMPILE=$toolchain_path
echo "+ CROSS_COMPILE=$CROSS_COMPILE"
export ARCH=$device_arch
echo "+ ARCH=$ARCH"
echo "+ building config $defconfig_name"
echo "+ Using $jobs threads"

echo " "

start_build;

function start_build {
	local mess=0
	
	echo "-> Starting build..."
	echo " "
	
	# Let's check does defconfig file exist
	echo "+ Checking if $defconfig_name exists in $PWD/arch/$ARCH/configs/"
	if [ ! -e "$PWD/arch/$ARCH/configs/$defconfig_name" ]; then
		echo "++ ERROR: defconfig doesn't exist. Check the filename and file presence and try again"
		exit
	fi
	
	echo " "
	# Let's check if make defconfig was already run
	echo "+ Checking for existing configuration..."
	if [ ! -e "$PWD/.config" ]; then
		echo "++ Kernel configuration not found. Creating new..."
		make $defconfig_name;
		
		# Check if configuration is actually made
		if [ -e "$PWD/.config" ]; then
			echo " "
			echo "+++ New configuration created, cleaning mess..."
			echo " "
			make clean
		else
			echo " "
			echo "+++ ERROR: make defconfig never finished, aborting..."
			exit
		fi
	else
		echo "++ Kernel configuration found. Do you want to reuse it or write new?"
		select ans in "New" "Reuse"; do
			case $ans in
				New )
					echo " "
					echo "+++ Clean up..."
					make mrproper
					echo " "
					echo "+++ Writing new .config file...";
					make $defconfig_name;
					
					# Check if configuration is actually made
					if [ -f "$PWD/.config" ]; then
						echo "++++ New configuration created"
					else
						echo "++++ ERROR: make defconfig never finished, aborting..."
						exit
					fi
					break;;
				Reuse )
					echo "+++ Configuration will be reused"
					echo " "
					$mess=1
					break;;
			esac
		done
	fi
	
	if [ $mess==1 ]; then
		echo "+ Your build folder is 'dirty', do you want to clean it?"
		select ans in "y" "n"; do
			case $ans in
				y )
					echo "++ Cleaning build dir..."
					echo " "
					make clean
					$mess=0
					break;;
				n ) 
					break;;
			esac
		done
	fi
			
	# Check for any last minute changes
	echo "+ Everything looks steady and ready. Do you want to make some final changes to the config?"
	select yn in "y" "n"; do
		case $yn in
			y ) 
				echo "++ Running make menuconfig. Don't forget to save!";
				echo " ";
				make menuconfig;
				break;;
			n ) 
				echo "++ Ok, ready to continue."
				echo " "
				break;;
		esac
	done
	echo "+ Press any key to start."
	read blah
	echo " "				
	make -j$jobs;
	
	# Check if build was a success and if yes, ask user for boot.img generation
	if [ -e $PWD/arch/arm/zImage ]; then
		echo " "
		echo "+ Build successful. Do you want to generate boot img?"
		select bla in "y" "n"; do
			case $bla in
				y ) 
					generate_bootImg
					echo " "
					echo "+++++++++++++++ FINISHED +++++++++++++++++"
					break
				n )
					echo "+++++++++++++++ FINISHED +++++++++++++++++"
					exit;;
			esac
		done
	else
		echo " "
		echo "+ Build failed; check output for errors and try again after fixing them"
		exit;;
	fi
}

function generate_bootImg {
	# Check if abootimg binary exist
	echo "-> Starting boot.img generation"
	echo " "
	
	echo "+ Checking if abootimg is in PATH.."
	if [ hash abootimg 2>/dev/null ]; then
		echo "++ abootimg found."
	else
		echo "++ abootimg binary not found; aborting"
		exit
	fi
	
	# Check if there is existing, example boot.img to use as template
	echo " "
	echo "+ Checking if template boot.img exists..."
	if [ -e "$PWD/build_tools/template_img/$template_bootimg" ]; then
		echo "++ Template boot.img found, extracting"
		abootimg -x "template_img/$template_bootimg"
		mv bootimg.cfg "template_img/"
		mv initrd.img "template_img/"
		mv zImage "template_img/"
		echo " "
		echo "++ Template extracted"
	else
		echo "++ Template boot.img not found, aborting."
		exit
	fi
	
	# Generate new boot.img
	echo "+ Starting generation of new boot.img"
	echo " "
	echo "++ Copying zImage from arch/$ARCH/boot..."
	cp -rvf "arch/$ARCH/boot/zImage"
	echo "++ Generating boot.img"
	abootimg --create boot.img -f template_img/bootimg.cfg -k zImage -r template_img/initrd.img
	if [ -e "$PWD/build_tools/boot.img"	]; then
		echo "+++ Success, boot.img generated"
	else
		echo "+++ Failure, boot.img not generated, aborting"
	fi
	
	# Generate flashable zip.
	# TODO
}


