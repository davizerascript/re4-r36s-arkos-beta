# Resident Evil 4 Mobile — v0.3.4-beta screen-fix

This is an experimental personal-use build for dArkOSRE/dArkOSEN testing.

## Physical-test finding

The reported device log showed that the ARMHF loader and both game libraries loaded successfully, all Android lifecycle callbacks returned, the SDL/OpenGL surface was created and the host processed 28,810 frames. The screen remained blank, so the failure was after process startup and inside the graphics presentation path.

## Changes

- Source the PortMaster CFW-specific `libgl_<CFW_NAME>.txt`, falling back to `libgl_default.txt`, following the official SDL/OpenGL launcher flow.
- Allow the CFW to select its libgl4es/GLES/EGL compatibility layer.
- Default `RE4_GL_MINIMAL=1`, `RE4_GL_NO_STENCIL=1` and `RE4_DESKTOP_GL=0` for Mali-G31/EGL compatibility.
- Keep the horizontal 640×480 presentation and do not force LCD rotation.
- Keep the self-contained ARMHF runtime for images with older system glibc.
- Add diagnostics for the selected PortMaster libgl file and graphics flags.

## Validation

The launcher passes `bash -n` and the metadata parses as valid JSON. The ARMHF host was already confirmed to load and process frames in the isolated test environment. Physical rendering, controls, audio, cutscenes and sustained gameplay still require testing on the target device.

The previous v0.3.3-glibc-test release remains available for rollback. Do not replace firmware, DTB, boot.ini, EGL or GLES files.
