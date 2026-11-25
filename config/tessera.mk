PRODUCT_PACKAGES += \
    TesseraHome \
    TesseraMetroFrameworkOverlay \
    TesseraMetroSystemUIOverlay \
    TesseraMetroSettingsOverlay \
    TesseraFontSelawikOverlay

PRODUCT_COPY_FILES += \
    vendor/tessera/prebuilt/etc/permissions/privapp-permissions-tessera.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-tessera.xml \
    vendor/tessera/prebuilt/etc/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml \
    vendor/tessera/fonts/selawik_light.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/Selawik-Light.ttf \
    vendor/tessera/fonts/selawik_semilight.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/Selawik-SemiLight.ttf \
    vendor/tessera/fonts/selawik_regular.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/Selawik-Regular.ttf \
    vendor/tessera/fonts/selawik_semibold.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/Selawik-SemiBold.ttf \
    vendor/tessera/fonts/selawik_bold.ttf:$(TARGET_COPY_OUT_PRODUCT)/fonts/Selawik-Bold.ttf

PRODUCT_SYSTEM_PROPERTIES += \
    ro.tessera.version=1.0-Alpha \
    ro.tessera.codename=Metro \
    ro.tessera.maintainer=BruxinCore \
    ro.tessera.build_type=UNOFFICIAL \
    ro.com.google.ime.theme_id=5 \
    persist.sys.theme.accent=0050EF

DEVICE_PACKAGE_OVERLAYS += \
    vendor/tessera/overlay/common
