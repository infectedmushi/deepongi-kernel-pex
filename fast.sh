#!/usr/bin/env bash

# This is a script to build an android kernel and push it to a telegram channel
# It is meant to be run on a CI server, but can be run locally as well
# It requires the following environment variables to be set:
# - TOKEN: The telegram bot token
# - CHAT_ID: The chat id to send the message to

export USE_CCACHE=true
export CCACHE_EXEC=/usr/bin/ccache

KERNEL_DIR="${PWD}"
cd "${KERNEL_DIR}"
CHEAD="$(git rev-parse --short HEAD)"
KERN_IMG="${KERNEL_DIR}"/out/arch/arm64/boot/Image
KERN_DTB="${KERNEL_DIR}"/out/arch/arm64/boot/dtbo.img
ANYKERNEL=/mnt/Bathtube/anykernel

# Repo URL
ANYKERNEL_REPO="https://github.com/Blaster4385/anykernel.git"
ANYKERNEL_BRANCH="master"

# Repo info
PARSE_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
PARSE_ORIGIN="$(git config --get remote.origin.url)"
COMMIT_POINT="$(git log --pretty=format:'%h : %s' -1)"

# Defconfig
DEFCONFIG="vendor/kona-perf_defconfig"

#Versioning
KERNEL="pex-kernel"

LINUX_VERSION="$(make kernelversion)"
DEVICE="oplus-sm8250"
KERNELNAME="${KERNEL}-${DEVICE}-$(date +%y%m%d-%H%M)"
ZIPNAME="${KERNELNAME}.zip"
	export PATH=/mnt/Hawai/toolchains/aarch64-linux-android/bin:/usr/local/bin:$ANDROID_HOME/bin:$JAVA_HOME/bin:$HOME/.bin:/home/infected_/.local/bin:$PATH
	export ARCH=arm64
    export CROSS_COMPILE=/mnt/Hawai/toolchains_new/gcc-linaro-12.2.1-2023.01-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
    export CROSS_COMPILE_ARM32=/mnt/Hawai/toolchains_new/gcc-linaro-12.2.1-2023.01-aarch64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
    make O=out mrproper
    make O=out CC=clang ${DEFCONFIG}
    make O=out CC=clang -j64

    cp "${KERN_IMG}" "${ANYKERNEL}"/Image
    cp "${KERN_DTB}" "${ANYKERNEL}"/dtbo.img


    # Zip the kernel, or fail
    cd "${ANYKERNEL}" || exit
    zip -r9 "${ZIPNAME}" ./*
    mv "${ZIPNAME}" /mnt/Bathtube/Out_Zips/"${ZIPNAME}"

    END=$(date +"%s")
    DIFF=$(( END - START ))


