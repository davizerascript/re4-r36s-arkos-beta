# Final validation report — Resident Evil 4 Mobile R36S/dArkOS PortMaster

**Date:** 28 August 2026
**Release:** `v0.3.2-beta`
**Asset:** `Resident-Evil-4-Mobile-R36S-dArkOS-PortMaster-fixed-v0.3.2.zip`

## Verdict

The corrected package is a **PortMaster port of the supplied Resident Evil 4 Mobile ARMHF build**. It is not a PS2 emulator, remake, or newly authored game. It adapts the supplied host and mobile data to the PortMaster/dArkOS launcher conventions.

The package follows the current PortMaster structure: a Bash launcher, a matching port directory, `port.json`, `gameinfo.xml`, README, screenshot and license material. PortMaster's packaging guidance requires this structure and documents `get_controls`, `SDL_GAMECONTROLLERCONFIG`, `pm_platform_helper`, gptokeyb and architecture-specific libraries [1] [2].

| Area | Result | Confidence |
|---|---|---:|
| PortMaster tree and metadata | 52 files, 35 assets, zero validator errors; official release checker passed | High |
| ARMHF architecture | Host is 32-bit ARM hard-float; launcher declares `PORT_32BIT=Y` | High |
| Asset names and paths | Proprietary data names match the host's file manager; misleading `.png` suffixes removed | High |
| Launcher/helper compatibility | Bash syntax passes; optional dArkOS variables are tolerated while sourcing helpers; false `DEVICE_ARCH` preflight gate removed | High |
| Logical display orientation | Host requests 640×480; no forced 90°/270° rotation or SDL/KMS/DRM backend | High for logical setup |
| Physical LCD image | Not observed on a real R36S | Unconfirmed |
| Input bridge | gptokeyb mapping and host key conversion are present; ARMHF smoke test reached a key event | Moderate |
| Physical buttons | Not pressed in the sandbox | Unconfirmed |
| Audio, saves, cutscenes and sustained play | Not physically exercised | Unconfirmed |

## Display and orientation

The supplied PS2 package was useful as a comparison because its retest documented a dArkOS issue where `DEVICE_NAME` had to be exported after PortMaster helpers and preserved through `sudo` so retrorun could select the correct R36S/RG351MP profile. That approach applies to retrorun-based cores.

Resident Evil 4 Mobile does not use retrorun. It creates its own SDL/OpenGL ES window. Therefore, copying a fixed 90° or 270° rotation from the PS2 wrapper would be unsafe. The final RE4 launcher leaves display backend selection to dArkOS/PortMaster, sets the native EGL selector when absent, and does not set `SDL_VIDEODRIVER`, `SDL_KMSDRM_ROTATION`, framebuffer orientation or DRM card selection.

A physical test on dArkOSRE and dArkOSEN displayed the launcher message “Este port requer ARMHF.” before the host started. The screenshot proves that the failure was in the launcher preflight, not in the game's rendering path. PortMaster can expose the firmware environment as `DEVICE_ARCH=aarch64` while still using its `PORT_32BIT=Y` path for 32-bit ports. Revision v0.3.2 removes the literal-value rejection and logs the reported architecture; it still preserves the ARMHF host and lets the real execution status determine whether the firmware has 32-bit compatibility.

The host's disassembly shows `SDL_CreateWindow` being called with width **640** and height **480**. The included screenshot is also 640×480 and displays horizontal gameplay with vertical letterboxing. This is the correct logical orientation for the R36S 640×480 panel. The actual LCD result still depends on the dArkOS image and Mali-G31 EGL/GLES driver [3].

## Controls

The launcher loads PortMaster controls, preserves `SDL_GAMECONTROLLERCONFIG`, starts gptokeyb before the host and calls `pm_platform_helper` immediately before execution. The included mapping is:

| R36S control | Virtual input | Host mapping |
|---|---|---|
| D-pad | Arrow keys | Android directional codes |
| A / B | `z` / `x` | Android 96 / 97 |
| X / Y | `a` / `q` | Android 102 / 104 |
| L1 / R1 | `s` / `w` | Android 103 / 105 |
| Start / Back | Enter / Escape | Android enter / back |

This confirms that the port is not missing an input path. The dArkOSRE/dArkOSEN screenshot did not reach gameplay, so physical button behavior remains unconfirmed until the host passes the corrected preflight on the same device.

## Runtime tests

The final tree passed `bash -n` and the reprodutible release validator. The host loaded the ARMHF libraries under QEMU, completed the fake Android lifecycle (`JNI_OnLoad`, `onCreate`, `onResume`, `onSurfaceCreated`, `onSurfaceChanged`) and reached `draw frame 0`, `draw frame 1` and `draw frame 2`.

A separate run with `SDL_VIDEODRIVER=dummy` failed because SDL's dummy backend does not provide an OpenGL context. That result is treated as a laboratory limitation, not as evidence that the dArkOS/Mali display path fails. No physical R36S was available for definitive LCD, controls or audio validation.

## Installation

Extract the release ZIP directly into `/roms/ports/`, or into `/roms2/ports/` when the second ArkOS card is active. The archive's top level contains `Resident Evil 4 Mobile.sh` and `residentevil4/`; do not add another outer folder. Keep the host, `lib/`, `data/monhun/`, save directory and `.gptk` mapping together.

Do not replace DTBs, `boot.ini`, RetroArch, EGL or GLES files. If the screen is black, preserve `residentevil4/log.txt`; if the screen is rotated, record the dArkOS version and the values reported for device/display variables; if buttons fail, record which physical buttons were tested.

## Limitations

This v0.3.2 release should be described as **corrected for dArkOSRE/dArkOSEN preflight and ready for physical testing**, not as physically certified. The open items are the actual LCD image, Mali-G31 driver behavior, ALSA audio, button order, saves, cutscenes, sustained performance and clean return to EmulationStation.

## References

[1]: https://portmaster.games/packaging.html "PortMaster — Packaging Ports"

[2]: https://github.com/christianhaitian/PortMaster/blob/main/docs/packaging.md "PortMaster — packaging and controls documentation"

[3]: https://github.com/southoz/dArkOSRE-R36 "dArkOSRE-R36 — dArkOS R36 source/rootfs reference"
