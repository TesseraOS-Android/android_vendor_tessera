#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(pwd)}"
WORK_DIR="/tmp/mtg16_fetch"
MTG_TAG="MindTheGapps-16.0.0-arm64-20261023_034858"
MTG_ZIP="${MTG_TAG}.zip"
MTG_URL="https://github.com/MindTheGapps/16.0.0-arm64/releases/download/${MTG_TAG}/${MTG_ZIP}"
MTG_SHA_URL="${MTG_URL}.sha256sum"

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
if [ ! -f "$MTG_ZIP" ]; then
  curl -fsSL -o "$MTG_ZIP" "$MTG_URL"
fi
curl -fsSL -o "${MTG_ZIP}.sha256sum" "$MTG_SHA_URL"
sha256sum -c "${MTG_ZIP}.sha256sum"

GAPPS_DIR="${ROOT_DIR}/vendor/gapps"
rm -rf "$GAPPS_DIR"
mkdir -p "${GAPPS_DIR}/proprietary"

unzip -qo "$MTG_ZIP" \
  "system/product/priv-app/GmsCore/*" \
  "system/product/priv-app/Phonesky/*" \
  "system/product/priv-app/GooglePartnerSetup/*" \
  "system/product/app/GoogleCalendarSyncAdapter/*" \
  "system/product/app/GoogleContactsSyncAdapter/*" \
  "system/product/overlay/GmsOverlay.apk" \
  "system/product/overlay/GmsSettingsOverlay.apk" \
  "system/product/overlay/GmsSettingsProviderOverlay.apk" \
  "system/product/etc/default-permissions/default-permissions-google.xml" \
  "system/product/etc/default-permissions/default-permissions-mtg.xml" \
  "system/product/etc/init/gapps.rc" \
  "system/product/etc/permissions/privapp-permissions-google-product.xml" \
  "system/product/etc/permissions/privapp-permissions-mtg.xml" \
  "system/product/etc/security/fsverity/gms_fsverity_cert.der" \
  "system/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml" \
  "system/product/etc/sysconfig/google.xml" \
  "system/product/etc/sysconfig/sysconfig-mtg.xml" \
  "system/product/lib64/libjni_latinimegoogle.so" \
  "system/system_ext/priv-app/GoogleServicesFramework/*" \
  "system/system_ext/priv-app/GoogleFeedback/*" \
  "system/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml" \
  -d "${GAPPS_DIR}/proprietary"

cat <<'EOF' > "${GAPPS_DIR}/Android.bp"
android_app_import {
    name: "GmsCore",
    owner: "google",
    apk: "proprietary/system/product/priv-app/GmsCore/GmsCore.apk",
    presigned: true,
    preprocessed: true,
    privileged: true,
    product_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "Phonesky",
    owner: "google",
    apk: "proprietary/system/product/priv-app/Phonesky/Phonesky.apk",
    presigned: true,
    preprocessed: true,
    privileged: true,
    product_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "GooglePartnerSetup",
    owner: "google",
    apk: "proprietary/system/product/priv-app/GooglePartnerSetup/GooglePartnerSetup.apk",
    presigned: true,
    preprocessed: true,
    privileged: true,
    product_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "GoogleCalendarSyncAdapter",
    owner: "google",
    apk: "proprietary/system/product/app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk",
    presigned: true,
    preprocessed: true,
    product_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "GoogleContactsSyncAdapter",
    owner: "google",
    apk: "proprietary/system/product/app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk",
    presigned: true,
    preprocessed: true,
    product_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "GoogleServicesFramework",
    owner: "google",
    apk: "proprietary/system/system_ext/priv-app/GoogleServicesFramework/GoogleServicesFramework.apk",
    presigned: true,
    preprocessed: true,
    privileged: true,
    system_ext_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

android_app_import {
    name: "GoogleFeedback",
    owner: "google",
    apk: "proprietary/system/system_ext/priv-app/GoogleFeedback/GoogleFeedback.apk",
    presigned: true,
    preprocessed: true,
    privileged: true,
    system_ext_specific: true,
    dex_preopt: {
        enabled: false,
    },
}

cc_prebuilt_library_shared {
    name: "libjni_latinimegoogle",
    owner: "google",
    product_specific: true,
    strip: {
        none: true,
    },
    target: {
        android_arm64: {
            srcs: ["proprietary/system/product/lib64/libjni_latinimegoogle.so"],
        },
    },
    compile_multilib: "64",
    check_elf_files: false,
}
EOF

cat <<'EOF' > "${GAPPS_DIR}/Android.mk"
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := GmsOverlay
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := proprietary/system/product/overlay/GmsOverlay.apk
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/overlay
LOCAL_MODULE_SUFFIX := .apk
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := GmsSettingsOverlay
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := proprietary/system/product/overlay/GmsSettingsOverlay.apk
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/overlay
LOCAL_MODULE_SUFFIX := .apk
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := GmsSettingsProviderOverlay
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := proprietary/system/product/overlay/GmsSettingsProviderOverlay.apk
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_PRODUCT)/overlay
LOCAL_MODULE_SUFFIX := .apk
include $(BUILD_PREBUILT)
EOF

cat <<'EOF' > "${GAPPS_DIR}/gapps.mk"
PRODUCT_PACKAGES += \
    GmsCore \
    Phonesky \
    GooglePartnerSetup \
    GoogleCalendarSyncAdapter \
    GoogleContactsSyncAdapter \
    GoogleServicesFramework \
    GoogleFeedback \
    GmsOverlay \
    GmsSettingsOverlay \
    GmsSettingsProviderOverlay \
    libjni_latinimegoogle

PRODUCT_COPY_FILES += \
    vendor/gapps/proprietary/system/product/etc/default-permissions/default-permissions-google.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-google.xml \
    vendor/gapps/proprietary/system/product/etc/default-permissions/default-permissions-mtg.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default-permissions-mtg.xml \
    vendor/gapps/proprietary/system/product/etc/init/gapps.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/gapps.rc \
    vendor/gapps/proprietary/system/product/etc/permissions/privapp-permissions-google-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-google-product.xml \
    vendor/gapps/proprietary/system/product/etc/permissions/privapp-permissions-mtg.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-mtg.xml \
    vendor/gapps/proprietary/system/product/etc/security/fsverity/gms_fsverity_cert.der:$(TARGET_COPY_OUT_PRODUCT)/etc/security/fsverity/gms_fsverity_cert.der \
    vendor/gapps/proprietary/system/product/etc/sysconfig/google-hiddenapi-package-allowlist.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google-hiddenapi-package-allowlist.xml \
    vendor/gapps/proprietary/system/product/etc/sysconfig/google.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/google.xml \
    vendor/gapps/proprietary/system/product/etc/sysconfig/sysconfig-mtg.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/sysconfig-mtg.xml \
    vendor/gapps/proprietary/system/system_ext/etc/permissions/privapp-permissions-google-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-google-system-ext.xml
EOF

echo "vendor/gapps bootstrapped cleanly at ${GAPPS_DIR}"
