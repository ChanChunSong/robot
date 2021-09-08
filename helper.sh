working_kernel_folder="/usr/local/google/home/oceanchen/kernel-repo/gs-mainline-5.10_manifest_7667484"
working_kernel_folder="/usr/local/google/home/oceanchen/kernel-repo/gs-mainline-5.10-blueport"

export ANDROID_SERIAL=0af4ad3da213
export ANDROID_SERIAL=0B231LQG60002V

build_local_kernel()
{
	cd $working_kernel_folder
	cd private/gs-google
	git diff > ~/temp/temp.patch
	cd ../../aosp
	git reset --hard HEAD
	patch -p1 < ~/temp/temp.patch
	cd ..
	# BUILD_KERNEL=1 ./build_slider.sh
	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest BUILD_KERNEL=1 ./build_slider.sh
}

update_local_kernel()
{
	cd $working_kernel_folder
	cd out/mixed/dist
	fastboot flash boot boot.img
	fastboot flash vendor_boot vendor_boot.img
	fastboot reboot fastboot
	fastboot flash vendor_dlkm vendor_dlkm.img
	fastboot reboot
	cd -
}

t1()
{
	cd $working_kernel_folder
	cd private/gs-google
	git diff > ~/temp/temp.patch
	cd ../../aosp
	git reset --hard HEAD
	patch -p1 < ~/temp/temp.patch
	cd ..
	# BUILD_KERNEL=1 ./build_slider.sh
	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest_1 BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_1.img
	mv vendor_boot.img vendor_boot_1.img
	mv vendor_dlkm.img vendor_dlkm_1.img
	cd -

	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest_2 BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_2.img
	mv vendor_boot.img vendor_boot_2.img
	mv vendor_dlkm.img vendor_dlkm_2.img
	cd -

	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest_3 BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_3.img
	mv vendor_boot.img vendor_boot_3.img
	mv vendor_dlkm.img vendor_dlkm_3.img
	cd -

	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest_4 BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_4.img
	mv vendor_boot.img vendor_boot_4.img
	mv vendor_dlkm.img vendor_dlkm_4.img
	cd -

	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest_5 BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_5.img
	mv vendor_boot.img vendor_boot_5.img
	mv vendor_dlkm.img vendor_dlkm_5.img
	cd -

	GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest BUILD_KERNEL=1 ./build_blueport.sh
	cd out/mixed/dist
	mv boot.img boot_ori.img
	mv vendor_boot.img vendor_boot_ori.img
	mv vendor_dlkm.img vendor_dlkm_ori.img
	cd -
}

# t1

export ANDROID_SERIAL=0af4ad3da213
# export ANDROID_SERIAL=0B231LQG60002V

set -x

adb reboot bootloader
	cd $working_kernel_folder/out/mixed/dist
	fastboot flash boot boot_ori.img
	fastboot flash vendor_boot vendor_boot_ori.img
	fastboot reboot fastboot
	fastboot flash vendor_dlkm vendor_dlkm_ori.img
	fastboot reboot
	cd -
adb wait-for-device
./check -s 0af4ad3da213 loop/001

# adb reboot bootloader
# 	cd $working_kernel_folder/out/mixed/dist
# 	fastboot flash boot boot_1.img
# 	fastboot flash vendor_boot vendor_boot_1.img
# 	fastboot reboot fastboot
# 	fastboot flash vendor_dlkm vendor_dlkm_1.img
# 	fastboot reboot
# 	cd -
# adb wait-for-device
# ./check -s 0af4ad3da213 loop/001

# adb reboot bootloader
# 	cd $working_kernel_folder/out/mixed/dist
# 	fastboot flash boot boot_2.img
# 	fastboot flash vendor_boot vendor_boot_2.img
# 	fastboot reboot fastboot
# 	fastboot flash vendor_dlkm vendor_dlkm_2.img
# 	fastboot reboot
# 	cd -
# adb wait-for-device
# ./check -s 0af4ad3da213 loop/001

# adb reboot bootloader
# 	cd $working_kernel_folder/out/mixed/dist
# 	fastboot flash boot boot_3.img
# 	fastboot flash vendor_boot vendor_boot_3.img
# 	fastboot reboot fastboot
# 	fastboot flash vendor_dlkm vendor_dlkm_3.img
# 	fastboot reboot
# 	cd -
# adb wait-for-device
# ./check -s 0af4ad3da213 loop/001

# adb reboot bootloader
# 	cd $working_kernel_folder/out/mixed/dist
# 	fastboot flash boot boot_4.img
# 	fastboot flash vendor_boot vendor_boot_4.img
# 	fastboot reboot fastboot
# 	fastboot flash vendor_dlkm vendor_dlkm_4.img
# 	fastboot reboot
# 	cd -
# adb wait-for-device
# ./check -s 0af4ad3da213 loop/001

# adb reboot bootloader
# 	cd $working_kernel_folder/out/mixed/dist
# 	fastboot flash boot boot_5.img
# 	fastboot flash vendor_boot vendor_boot_5.img
# 	fastboot reboot fastboot
# 	fastboot flash vendor_dlkm vendor_dlkm_5.img
# 	fastboot reboot
# 	cd -
# adb wait-for-device
# ./check -s 0af4ad3da213 loop/001

set +x