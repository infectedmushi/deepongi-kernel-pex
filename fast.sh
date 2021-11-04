#!/bin/bash
export KERNEL_DIR="/mnt/Building/infected-kernel"
export KBUILD_OUTPUT="/mnt/Building/infected-kernel/out"
export ZIP_DIR="/mnt/Building/AnyKernel3"
export ZIP_OUT_DIR="/mnt/Building/Out_Zips"
git submodule init
git submodule update
#make mrproper
#rm -rf out
export PATH="/home/infected_/bin:/home/infected_/platform-tools:/mnt/Building/proton-clang/bin:$PATH"
export USE_CCACHE=1
export ARCH=arm64
DTBIMAGE="dtb"
export VARIANT="infected-kernel-r04"
export HASH=`git rev-parse --short=4 HEAD`
export KERNEL_ZIP="$VARIANT-$HASH"
export LOCALVERSION=~`echo $KERNEL_ZIP`
make O=$KBUILD_OUTPUT CC=clang instantnoodle_defconfig
make -j$(nproc --all) O=$KBUILD_OUTPUT CC=clang CROSS_COMPILE=/mnt/Building/linaro_aarch64-linux-gnu/bin/aarch64-linux-gnu- CROSS_COMPILE_COMPAT=/mnt/Building/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/arm-none-eabi-
cp -v $KBUILD_OUTPUT/arch/arm64/boot/Image.gz-dtb $ZIP_DIR/Image.gz-dtb
cd $ZIP_DIR
zip -r9 $VARIANT-$HASH.zip *
mv -v $VARIANT-$HASH.zip $ZIP_OUT_DIR/
echo -e "${green}"
echo "-------------------"
echo "Build Completed"
echo "-------------------"
echo -e "${restore}"
echo "                                                     "
echo "  _       __        _          _     _      _        "
echo " (_)_ _  / _|___ __| |_ ___ __| |___| |__ _| |__ ___ "
echo " | | ' \|  _/ -_) _|  _/ -_) _  |___| / _  | '_ (_-< "
echo " |_|_||_|_| \___\__|\__\___\__,_|   |_\__,_|_.__/__/ "
echo "                                                     "
echo "                                                     "
                                               
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
