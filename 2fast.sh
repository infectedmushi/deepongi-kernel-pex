#!/bin/bash
KERNEL_DIR="/mnt/Building/infected-kernel"
PRODUCT_OUT=${KERNEL_DIR}/out
#MKBOOTTOOL_DIR=${LOCAL_DIR}/system/core/mkbootimg
AK3="/mnt/Building/AK3"
ZIP_OUT_DIR="/mnt/Building/Out_Zips"

export PATH="/home/infected_/bin:/home/infected_/platform-tools:/mnt/Building/proton-clang/bin:$PATH"
export USE_CCACHE=1
export ARCH=arm64
DTBIMAGE="dtb"
export VARIANT="infected-r005"
export HASH=`git rev-parse --short=4 HEAD`
export KERNEL_ZIP="$VARIANT-$HASH"
export LOCALVERSION=~`echo $KERNEL_ZIP`


function check_build_result()
{
	if [ $? != 0 ]; then
		echo -e "\033[31m $1 build fail! \033[0m"
		exit -1
	else
		echo -e "\033[32m $1 build success! \033[0m"
	fi
}

cd ${KERNEL_DIR}
make clean
make mrproper
rm -rf out
make O=${PRODUCT_OUT} CC=clang instantnoodle_defconfig
make O=${PRODUCT_OUT} -j$(nproc --all) CC=clang CROSS_COMPILE=/mnt/Building/linaro_aarch64-linux-gnu/bin/aarch64-linux-gnu- CROSS_COMPILE_COMPAT=/mnt/Building/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/arm-none-eabi-
check_build_result "Kernel Image"

cp -v ${PRODUCT_OUT}/arch/arm64/boot/Image.gz-dtb ${AK3}/Image.gz-dtb

#make -j$(nproc --all) O=$KBUILD_OUTPUT CC=clang CROSS_COMPILE=/mnt/Building/linaro_aarch64-linux-gnu/bin/aarch64-linux-gnu- CROSS_COMPILE_COMPAT=/mnt/Building/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/arm-none-eabi-
#cp -v ${PRODUCT_OUT}/arch/arm64/boot/Image.gz-dtb $ZIP_DIR/Image.gz-dtb
cd ${AK3}
zip -r9 $VARIANT-$HASH.zip *
mv -v $VARIANT-$HASH.zip $ZIP_OUT_DIR/
echo -e "${green}"
echo "-------------------"
echo "Build Completed"
echo "-------------------"
echo -e "${restore}"
