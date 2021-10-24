#!/bin/bash
KERNEL_DIR="/mnt/Building/android_kernel_oneplus_sm8250"
KBUILD_OUTPUT="/mnt/Building/android_kernel_oneplus_sm8250/out"
ZIP_DIR="/mnt/Building/AnyKernel3"
export USE_CCACHE=1
export ARCH=arm64
make clean && make mrproper
# make installclean
# rm -rf out
time make O=$KBUILD_OUTPUT CC=clang instantnoodle_defconfig
export DTC_EXT=dtc
export VARIANT="OP8-OOS-R"
export HASH=`git rev-parse --short=8 HEAD`
export KERNEL_ZIP="$VARIANT-$(date +%y%m%d)-$HASH"
export LOCALVERSION=~`echo $KERNEL_ZIP`
export KBUILD_BUILD_USER=infected_
export KBUILD_BUILD_HOST=infected-labs
export KBUILD_COMPILER_STRING=$($CLANG_PATH --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
export PATH="/mnt/Building/proton-clang/bin:${PATH}"
time make -j$(nproc --all) O=$KBUILD_OUTPUT CC=clang CROSS_COMPILE=/mnt/Building/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf/bin/aarch64-none-elf- CROSS_COMPILE_COMPAT=/mnt/Building/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/arm-none-eabi-
find $KBUILD_OUTPUT/arch/arm64/boot/dts/vendor/qcom -name '*.dtb' -exec cat {} + > $ZIP_DIR/dtb
cp -v $KBUILD_OUTPUT/arch/arm64/boot/Image.gz $ZIP_DIR/Image.gz
cp -v $KBUILD_OUTPUT/arch/arm64/boot/dtbo.img $ZIP_DIR/dtbo.img
cd $ZIP_DIR
zip -r9 $VARIANT-$(date +%y%m%d)-$HASH.zip *
mv -v $VARIANT-$(date +%y%m%d)-$HASH.zip /mnt/Building/Out_Zips
echo -e "${green}"
echo "-------------------"
echo "Build Completed"
echo "-------------------"
echo -e "${restore}"
