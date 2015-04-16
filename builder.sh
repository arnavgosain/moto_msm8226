#!/bin/bash
echo "Welcome to Velvet Kernel Builder!"
LC_ALL=C date +%Y-%m-%d
toolchain="/home/arnavgosain/velvet/toolchains/google-gcc-arm-eabi-4.8/bin/arm-eabi-"
build=/home/arnavgosain/velvet/out/"$device"
kernel="velvet"
version="R1"
rom="cm"
vendor="moto"
date=`date +%Y%m%d`
config=velvet_"$device"_defconfig
kerneltype="zImage"
jobcount="-j$(grep -c ^processor /proc/cpuinfo)"
export KBUILD_BUILD_USER=arnavgosain
export KBUILD_BUILD_HOST=velvet

echo "Checking for build..."
if [ -d arch/arm/boot/"$kerneltype" ]; then
	read -p "Previous build found, clean working directory..(y/n)? : " cchoice
	case "$cchoice" in
		y|Y )
			export ARCH=arm
			export CROSS_COMPILE=$toolchain
			make clean && make mrproper
			echo "Working directory cleaned...";;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " dchoice
	case "$dchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;

		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
fi
echo "Extracting files..."
if [ -f arch/arm/boot/"$kerneltype" ]; then
	mv arch/arm/boot/"$kerneltype" zip-"$device"/tools
else
	echo "Nothing has been made..."
	read -p "Clean working directory..(y/n)? : " achoice
	case "$achoice" in
		y|Y )
			export ARCH=arm
                        export CROSS_COMPILE=$toolchain
                        make clean && make mrproper
                        echo "Working directory cleaned...";;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " bchoice
	case "$bchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
fi

echo "Zipping..."
if [ -f zip-"$device"/tools/"$kerneltype" ]; then
	cd zip-"$device"
	zip -r ../"$kernel"."$version"-"$rom"."$vendor"."$device"."$date".zip .
	mv ../"$kernel"."$version"-"$rom"."$vendor"."$device"."$date".zip $build
	rm tools/"$kerneltype"
	cd ..
	rm -rf arch/arm/boot/"$kerneltype"
	export OUT="$build"
	echo "Done..."
	exit 0;
else
	echo "No $kerneltype found..."
	exit 0;
fi
# Export script by Savoca
# Thank You Savoca!
