# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Call common.mk
$(call inherit-product, device/samsung/bcm21553-common/common.mk)

# Inherit from those products. Most specific first.
$(call inherit-product, build/target/product/languages_full.mk)
$(call inherit-product, build/target/product/full_base.mk)

# Add device package overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/totoro/overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/cyanogen/overlay/mdpi

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

# Add LDPI assets, in addition to LDPI
    PRODUCT_LOCALES += ldpi

# Kernel modules
PRODUCT_COPY_FILES += \
    device/samsung/totoro/prebuilt/root/fsr.ko:root/fsr.ko \
    device/samsung/totoro/prebuilt/root/fsr_stl.ko:root/fsr_stl.ko \
    device/samsung/totoro/prebuilt/root/rfs_fat.ko:root/rfs_fat.ko \
    device/samsung/totoro/prebuilt/root/rfs_glue.ko:root/rfs_glue.ko \
    device/samsung/totoro/prebuilt/root/j4fs.ko:root/j4fs.ko \
    device/samsung/totoro/prebuilt/root/sec_param.ko:root/sec_param.ko

# Board-specific init
PRODUCT_COPY_FILES += \
    device/samsung/totoro/ramdisk/ueventd.gt-s5360.rc:root/ueventd.gt-s5360.rc \
    device/samsung/totoro/ramdisk/init.gt-s5360.rc:root/init.gt-s5360.rc

# Use the non-open-source parts, if they're present
-include vendor/samsung/totoro/BoardConfigVendor.mk

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/cyanogen/prebuilt/ldpi/media/bootanimation.zip:system/media/bootanimation.zip

# Other kernel modules not in ramdisk
ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/samsung/totoro/prebuilt/kernel
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# See comment at the top of this file. This is where the other
# half of the device-specific product definition file takes care
# of the aspects that require proprietary drivers that aren't
# commonly available
$(call inherit-product-if-exists, vendor/samsung/totoro/totoro-vendor.mk)
