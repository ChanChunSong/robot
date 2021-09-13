# 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

working_kernel_folder="/usr/local/google/home/oceanchen/kernel-repo/gs-mainline-5.10_manifest_7667484"
working_kernel_folder="/usr/local/google/home/oceanchen/kernel-repo/gs-mainline-5.10-blueport"
working_android_folder="Android/sc-dev"

export ANDROID_SERIAL=0af4ad3da213
export ANDROID_SERIAL=0B231LQG60002V
export ANDROID_SERIAL=13131FDEE00036 # raven
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

build_kernel_with_remote_build()
{
	ssh workstation "\
		cd ~/kernel-repo; \
		cd $working_kernel_target; \
		cd private/gs-google/; \
		git diff > ~/temp/temp.patch; \
		cd -; \
		cd aosp; \
		patch -p1 < ~/temp/temp.patch; \
		cd -; \
		GKI_DEFCONFIG_FRAGMENT=private/gs-google/build.config.slider.blktest BUILD_KERNEL=1 ./build_slider.sh"
}

update_remote_kernel_build()
{
	cd $local_kernel_path/$working_kernel_target
	cd out/mixed/dist/
	fastboot flash boot boot.img
	fastboot flash vendor_boot vendor_boot.img
	fastboot reboot fastboot
	fastboot flash vendor_boot vendor_boot.img
	fastboot reboot
}

update_binary()
{
	# remote_mounted=`mount | grep $working_android_folder | grep "sshfs"`

	# if [[ ! -z $remote_mounted ]]; then
	# 	remote_host=`echo $remote_mounted | cut -d ':' -f 1`
	# 	ssh $remote_host "cd $working_android_folder; \
	# 		find out/target/product/$1 -name \"$2\""
	# fi
	filepath=`adb shell find system vendor -name $2`
	cd ~
	cd $working_android_folder
	adb push out/target/product/$1/$filepath $filepath
	adb shell sync
}
# set -x
remote_android_build()
{
	ssh $1 "cd ~; \
		cd $working_android_folder; \
		source build/make/envsetup.sh && lunch $2-userdebug ; \
		m $3 -j54" 
}

catch_logcat()
{
	mkdir -p ~/log/
	cd ~/log/
	adb shell logcat -d > logcat
	strings logcat > logcat.txt
	subl logcat.txt
}

# remote_android_build cloudtop raven pixelstats-vendor
# update_binary raven libpixelstats.so
# update_binary raven pixelstats-vendor
catch_logcat
set +x