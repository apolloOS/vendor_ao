PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# General Properties
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# Google Stuff
ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/ao/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/ao/prebuilt/common/addon.d/50-backuptool.sh:system/addon.d/50-backuptool.sh \
    vendor/ao/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/ao/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

# Safemode script
PRODUCT_COPY_FILES += \
	vendor/ao/prebuilt/common/bin/safemode:system/bin/safemode

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# init.d support
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/ao/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/ao/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/ao/prebuilt/common/etc/init.d/01safemode:system/etc/init.d/01safemode

# Specific settings at boot
PRODUCT_COPY_FILES += \
	vendor/ao/prebuilt/common/etc/init.d/92aosettings:system/etc/init.d/92aosettings

# Init file
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/etc/init.local.rc:root/init.local.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/ao/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/ao/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# World APN list
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

# Overlays & Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += \
	vendor/ao/overlay/common \
	vendor/ao/overlay/dictionaries

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else
PRODUCT_COPY_FILES += \
    vendor/ao/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

# Make adb secured for non eng builds
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Additional packages
-include vendor/ao/config/packages.mk

# Versioning
ANDROID_VERSION = 7.0
PLATFORM_VERSION_CODENAME = REL
ifndef AO_BUILD_TYPE
    AO_BUILD_TYPE := alpha
endif
AO_VER := 0.1
ifdef AO_BUILD_TYPE
    AO_VERSION_NUMBER = $(AO_VER)-$(AO_BUILD_TYPE)
else
    AO_VERSION_NUMBER = $(AO_VER)
endif

ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
    AO_BUILD_TYPE :=$(TARGET_UNOFFICIAL_BUILD_ID)
endif

# Set all versions
AO_VERSION := AO_$(AO_BUILD)_$(ANDROID_VERSION)_$(shell date +%Y%m%d)_$(AO_VERSION_NUMBER)
AO_MOD_VERSION := AO_$(AO_BUILD)_$(ANDROID_VERSION)_$(shell date +%Y%m%d)_$(AO_VERSION_NUMBER)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.ao.version=$(AO_VERSION_NUMBER) \
    ro.mod.version=$(AO_BUILD_TYPE)-v$(AO_VERSION_NUMBER) \

$(call inherit-product-if-exists, vendor/extra/product.mk)
