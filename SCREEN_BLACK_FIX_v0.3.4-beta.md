# Resident Evil 4 Mobile — experimental screen fix v0.3.4-beta

The physical test reached the Android lifecycle, created the SDL/OpenGL surface and processed 28,810 frames, but the LCD remained blank. This means the ARMHF loader and game core were running; the remaining failure was in the graphics presentation path.

This test build changes the launcher in two ways:

1. It sources the PortMaster CFW-specific `libgl_<CFW_NAME>.txt` file, falling back to `libgl_default.txt`, matching the official PortMaster SDL/OpenGL launcher flow. This allows dArkOSRE/dArkOSEN to select their libgl4es/GLES/EGL compatibility layer.
2. It defaults the host compatibility flags `RE4_GL_MINIMAL=1`, `RE4_GL_NO_STENCIL=1` and `RE4_DESKTOP_GL=0`. These reduce framebuffer requirements for Mali-G31/EGL systems without rotating the display or changing the game's 640×480 horizontal orientation.

The missing weak C++ symbols (`__cxa_call_unexpected`, `__cxa_begin_cleanup`, `__cxa_type_match`) were not fatal in the reported run: both libraries loaded, JNI callbacks returned, the surface callbacks returned and the frame loop continued. They remain logged as a compatibility warning.

This is an experimental personal-use build. It has not been physically confirmed to render the game on the target dArkOS image. If it still shows a blank screen, preserve `residentevil4/log.txt` and report the new log; the `portmaster_gl_config` and `re4_gl_*` lines are important diagnostics.
