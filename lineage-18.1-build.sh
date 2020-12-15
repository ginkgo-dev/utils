#!/usr/bin/env bash

#
# LineageOS 18.1 build script
#

ORG_URL="https://github.com/ginkgo-dev"
MANIFEST_URL="git://github.com/LineageOS/android.git"
BRANCH="lineage-18.1"

repo init -u $MANIFEST_URL -b $BRANCH
repo sync --force-sync --no-tag --no-clone-bundle --optimized-fetch --current-branch -f -j16

git clone $ORG_URL/android_device_xiaomi_ginkgo -b $BRANCH device/xiaomi/ginkgo
git clone $ORG_URL/android_device_xiaomi_trinket-common -b $BRANCH device/xiaomi/trinket-common
git clone $ORG_URL/android_kernel_xiaomi_ginkgo -b $BRANCH kernel/xiaomi/ginkgo
git clone $ORG_URL/android_vendor_xiaomi_ginkgo -b $BRANCH vendor/xiaomi/ginkgo
git clone $ORG_URL/android_vendor_xiaomi_trinket-common -b $BRANCH vendor/xiaomi/trinket-common

rm -rf hardware/qcom-caf/sm8150/display
git clone $ORG_URL/android_hardware_qcom_display -b $BRANCH hardware/qcom-caf/sm8150/display

. build/envsetup.sh
lunch lineage_ginkgo-userdebug
mka bacon -j32
