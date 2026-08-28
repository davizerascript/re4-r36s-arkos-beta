# Resident Evil 4 Mobile — R36S/dArkOS PortMaster

> **Experimental beta port for testing.** This project adapts the supplied Resident Evil 4 Mobile ARMHF build to the PortMaster/dArkOS flow on R36S-class devices. It is not an official Capcom release, an emulator, or a remake.

## Corrected package

Download the complete asset from the [v0.3.1-beta release](../../releases/tag/v0.3.1-beta):

```text
Resident-Evil-4-Mobile-R36S-dArkOS-PortMaster-fixed-v0.3.1.zip
SHA-256: 8c4df72a1e6ff89e1fa9fb274c7fb92580bc06d5113b867cdce9b2c8cfad497d
Size: 96,071,786 bytes
```

The archive has the correct PortMaster installation level. Its top level contains `Resident Evil 4 Mobile.sh` and `residentevil4/`; do not wrap it in another directory.

## Installation

Extract the archive into the PortMaster ports directory. On a usual single-card dArkOS/R36S setup, the resulting paths are:

```text
/roms/ports/Resident Evil 4 Mobile.sh
/roms/ports/residentevil4/
```

When ArkOS is using the second card, use `/roms2/ports/` instead. Keep `re4_host`, `lib/`, `data/monhun/`, `save/`, the `.gptk` file and the launcher together. The package is **ARMHF**, not AArch64.

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

## Validation status

The corrected tree passed the local release validator with **52 files, 35 assets and zero errors**, and passed the PortMaster release checker. The ARMHF host loaded its native libraries under QEMU, completed the fake Android lifecycle, created its rendering path in headless mode and reached `draw frame 0`, `draw frame 1` and `draw frame 2`.

This is not a physical R36S certification. LCD/Mali-G31 presentation, ALSA audio, physical buttons, save/load, cutscenes, sustained gameplay and clean return to EmulationStation still require testing on the exact dArkOS image. A generic SDL dummy video backend cannot validate OpenGL because it has no GL context; that laboratory limitation is not evidence of a device failure.

## Credits and distribution

Port beta and supplied files are credited to **[@melo._.071](https://www.instagram.com/melo._.071/)**. The original game and proprietary assets remain the property of their respective rights holders. Do not redistribute the package without appropriate permission. This repository is not affiliated with Capcom.

See [`docs/VALIDATION_REPORT.md`](docs/VALIDATION_REPORT.md) for the detailed audit and [`RELEASE_NOTES_v0.3.1-beta.md`](RELEASE_NOTES_v0.3.1-beta.md) for the change summary.
