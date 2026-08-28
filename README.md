# Resident Evil 4 Mobile — R36S/dArkOS PortMaster

> **Experimental beta port for testing.** This project adapts the supplied Resident Evil 4 Mobile ARMHF build to the PortMaster/dArkOS flow on R36S-class devices. It is not an official Capcom release, an emulator, or a remake.
>
> **Compatibility fix v0.3.2-beta:** dArkOSRE and dArkOSEN may report `DEVICE_ARCH=aarch64` while PortMaster still supports 32-bit ARM ports. The launcher now relies on PortMaster's `PORT_32BIT=Y` signal and no longer aborts with the misleading “Este port requer ARMHF” message. The supplied host remains an ARMHF ELF; if the firmware lacks 32-bit execution support, the actual execution error is recorded in `residentevil4/log.txt`.

## Corrected package

Download the complete asset from the [v0.3.2-beta release](../../releases/tag/v0.3.2-beta):

```text
Resident-Evil-4-Mobile-R36S-dArkOS-PortMaster-fixed-v0.3.2.zip
SHA-256: 4802981d3d12fdb61a9066d4715fdd2c9f447fbd0985587068ea8b6c119011be
Size: 96,072,150 bytes
```

The archive has the correct PortMaster installation level. Its top level contains `Resident Evil 4 Mobile.sh` and `residentevil4/`; do not wrap it in another directory.

## Installation

Extract the archive into the PortMaster ports directory. On a usual single-card dArkOS/R36S setup, the resulting paths are:

```text
/roms/ports/Resident Evil 4 Mobile.sh
/roms/ports/residentevil4/
```

When ArkOS is using the second card, use `/roms2/ports/` instead. Keep `re4_host`, `lib/`, `data/monhun/`, `save/`, the `.gptk` file and the launcher together. The package contains an **ARMHF** host, but the launcher uses PortMaster's `PORT_32BIT=Y` compatibility signal and no longer rejects dArkOSRE/dArkOSEN merely because they report `DEVICE_ARCH=aarch64`. The package is not an AArch64 host.

## Display and controls

The host requests a **horizontal 640×480** SDL/OpenGL ES window. The launcher does not force a 90° or 270° rotation, KMS/DRM card, or SDL video backend; dArkOS/PortMaster keeps control of the native display path. The included screenshot is 640×480 with the game's horizontal letterboxed presentation.

The launcher loads PortMaster controls, starts gptokeyb, preserves the device's SDL controller configuration and calls `pm_platform_helper` before launching the host. The included mapping is:

| R36S control | Virtual input |
|---|---|
| D-pad | Arrow keys |
| A / B | `z` / `x` |
| X / Y | `a` / `q` |
| L1 / R1 | `s` / `w` |
| Start / Back | Enter / Escape |

The mapping is technically connected to the host's Android-key bridge, but physical button behavior still requires testing on the actual R36S.

## Experimental screen-fix build v0.3.4-beta

The physical test reached the game lifecycle and processed 28,810 frames but showed a blank LCD. The new experimental build sources the PortMaster `libgl_<CFW_NAME>.txt`/`libgl_default.txt` configuration and defaults `RE4_GL_MINIMAL=1`, `RE4_GL_NO_STENCIL=1` and `RE4_DESKTOP_GL=0` for Mali-G31/EGL compatibility. It does not change the horizontal 640×480 orientation or claim physical gameplay validation. Download it from the [v0.3.4-beta release](https://github.com/davizerascript/re4-r36s-arkos-beta/releases/tag/v0.3.4-beta).

## Validation status

The corrected tree passed the local release validator with **52 files, 35 assets and zero errors**, and passed the PortMaster release checker. The ARMHF host loaded its native libraries under QEMU, completed the fake Android lifecycle, created its rendering path in headless mode and reached `draw frame 0`, `draw frame 1` and `draw frame 2`.

This is not a physical R36S certification. LCD/Mali-G31 presentation, ALSA audio, physical buttons, save/load, cutscenes, sustained gameplay and clean return to EmulationStation still require testing on the exact dArkOS image. A generic SDL dummy video backend cannot validate OpenGL because it has no GL context; that laboratory limitation is not evidence of a device failure.

## Credits and distribution

Port beta and supplied files are credited to **[@melo._.071](https://www.instagram.com/melo._.071/)**. The original game and proprietary assets remain the property of their respective rights holders. Do not redistribute the package without appropriate permission. This repository is not affiliated with Capcom.

See [`docs/VALIDATION_REPORT.md`](docs/VALIDATION_REPORT.md) for the detailed audit, [`RELEASE_NOTES_v0.3.2-beta.md`](RELEASE_NOTES_v0.3.2-beta.md) for the previous compatibility fix and [`SCREEN_BLACK_FIX_v0.3.4-beta.md`](SCREEN_BLACK_FIX_v0.3.4-beta.md) for the current experimental screen fix.
