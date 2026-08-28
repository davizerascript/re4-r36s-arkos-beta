# Resident Evil 4 Mobile — R36S/dArkOS v0.3.1-beta

## Summary

This release repackages the supplied Resident Evil 4 Mobile ARMHF build in a PortMaster-compatible layout for experimental R36S/dArkOS testing.

## Fixes in this release

The archive no longer has an extra outer directory. Binary game assets use the extensions expected by the host instead of the misleading `.png` suffix. The launcher now declares `PORT_32BIT` before PortMaster helpers, tolerates optional variables missing from dArkOS helper files, supports `/roms` and `/roms2`, loads the local ARMHF libraries, starts gptokeyb before the host and runs `pm_platform_helper` before launch.

The launcher preserves the dArkOS EGL path through `SDL_VIDEO_EGL_DRIVER=libEGL.so` without forcing a display backend or a 90°/270° rotation. The host requests a horizontal 640×480 window. The mapping covers D-pad, A/B/X/Y, L1/R1, Start and Back through the included gptokeyb file.

## Validation

The local validator reported 52 files, 35 assets and zero errors. The official PortMaster release checker passed. The ARMHF host loaded under QEMU, completed its fake Android lifecycle and reached the first rendered frames in headless mode. The SDL dummy-video experiment is not treated as a graphics result because that backend cannot create an OpenGL context.

A physical R36S test remains required for LCD orientation, Mali-G31 EGL/GLES presentation, ALSA audio, physical buttons, saves, cutscenes, sustained play and clean return to EmulationStation. This release is experimental and is not marked ready-to-run.

## Asset

```text
Name: Resident-Evil-4-Mobile-R36S-dArkOS-PortMaster-fixed-v0.3.1.zip
SHA-256: 8c4df72a1e6ff89e1fa9fb274c7fb92580bc06d5113b867cdce9b2c8cfad497d
Size: 96,071,786 bytes
```

## Credits

Port beta and supplied files: **[@melo._.071](https://www.instagram.com/melo._.071/)**. The original game and proprietary assets remain the property of their respective rights holders. This is not an official Capcom release.
