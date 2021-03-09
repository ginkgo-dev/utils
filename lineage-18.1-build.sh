#!/usr/bin/env bash

#
# LineageOS 18.1 build script
#

ORG_URL="https://github.com/ginkgo-dev"
MANIFEST_URL="git://github.com/LineageOS/android.git"
BRANCH="lineage-18.1"

repo init -u $MANIFEST_URL -b $BRANCH
repo sync --force-sync -c -q --no-tag --no-clone-bundle --optimized-fetch --current-branch -f -j16 || exit 0

git clone $ORG_URL/android_device_xiaomi_ginkgo -b $BRANCH device/xiaomi/ginkgo
git clone $ORG_URL/android_kernel_xiaomi_ginkgo -b $BRANCH kernel/xiaomi/ginkgo
git clone $ORG_URL/android_vendor_xiaomi_ginkgo -b $BRANCH vendor/xiaomi/ginkgo
git clone $ORG_URL/android_prebuilts_clang_host_linux-x86_clang-sdllvm -b $BRANCH prebuilts/clang/host/linux-x86/clang-sdllvm

rm -rf hardware/qcom-caf/sm8150/display
git clone $ORG_URL/android_hardware_qcom_display -b $BRANCH hardware/qcom-caf/sm8150/display

cd packages/apps/Updater
git fetch $ORG_URL/android_packages_apps_Updater
git cherry-pick 76968d0f890a8362573f68d3218263139a11c14a # Updater: Switch to own changelog
cd ../../..

cd system/security
git fetch $ORG_URL/android_system_security
git cherry-pick 27be29e9049b256f801f0bd5fb2a51a4fd01ee4c
cd ../..

. build/envsetup.sh

repopick 297131 # overlays: Fix inactive state Wifi Icon in Circular,Filled Kai Icon Pack
repopick 297128 # StatusBar: Dismiss qs when screen's going off if showing
repopick 297129 # Properly set fonts and icons on keyguard when changing styles
repopick 297130 # LockIcon: refresh icon on overlay changes
repopick 300111 # SystemUI: Add a tile to show power menu
repopick 300112 # sdk: Add power button qs tile metric
repopick 300551 # WallpaperPicker2: Fix race condition for fast-loading wallpapers

lunch lineage_ginkgo-userdebug
mka bacon -j32
