android_vendor_tessera
======================

Vendor configuration, typography, and runtime resource overlays for TesseraOS (`vendor/tessera`).

Structure
---------

- `config/tessera.mk` - Product makefiles, system properties, and overlay packages
- `fonts/` - Selawik font family (Light, SemiLight, Regular, SemiBold, Bold)
- `prebuilt/etc/fonts_customization.xml` - System font family definitions
- `prebuilt/etc/permissions/privapp-permissions-tessera.xml` - Privileged permissions for `com.tesseraos.home`
- `rro_overlays/` - Framework, SystemUI, Settings, and font RRO packages

Credits
-------

- Android Open Source Project (AOSP)
- LineageOS
- Microsoft (Selawik Open Source Typeface, MIT License)
- BruxinCore (NerokiStyle)
