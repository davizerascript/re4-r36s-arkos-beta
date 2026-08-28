#!/bin/bash
set -u

# Resident Evil 4 Mobile — PortMaster / dArkOS / R36S
# ARMHF only. The game data remains inside the port directory.

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
PORTNAME="residentevil4"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# Tell PortMaster's CFW mods that this is a 32-bit ARMHF executable before
# control.txt/mod files and get_controls are evaluated.
export PORT_32BIT="Y"

# PortMaster control.txt is the source of CFW-specific paths, controls,
# architecture and helper functions. Keep a standalone fallback for direct
# terminal testing, but use the PortMaster variables whenever available.
if [ -d "/opt/system/Tools/PortMaster/" ]; then
    controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
    controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
    controlfolder="$XDG_DATA_HOME/PortMaster"
else
    controlfolder="/roms/ports/PortMaster"
fi

if [ -f "$controlfolder/control.txt" ]; then
    export controlfolder
    # Some dArkOS device_info/mod files reference optional variables that are
    # not defined on every image. Source helpers with nounset temporarily off.
    set +u
    # shellcheck disable=SC1090
    source "$controlfolder/control.txt"
    [ -f "${controlfolder}/mod_${CFW_NAME:-}.txt" ] && source "${controlfolder}/mod_${CFW_NAME:-}.txt"
    if declare -F get_controls >/dev/null 2>&1; then
        get_controls || true
    fi
    set -u
else
    directory="roms"
    ESUDO=""
    DEVICE_ARCH="armhf"
    GPTOKEYB=""
    sdl_controllerconfig=""
fi

# The PortMaster launcher can run from /roms or /roms2. Fall back to the
# directory next to this script so direct execution remains useful.
if [ -n "${directory:-}" ] && [ -d "/${directory}/ports/${PORTNAME}" ]; then
    GAMEDIR="/${directory}/ports/${PORTNAME}"
elif [ -d "$SCRIPT_DIR/${PORTNAME}" ]; then
    GAMEDIR="$SCRIPT_DIR/${PORTNAME}"
else
    echo "Resident Evil 4 Mobile: diretório do port não encontrado: $PORTNAME" >&2
    exit 1
fi

CONFDIR="$GAMEDIR/conf"
mkdir -p "$CONFDIR"
cd "$GAMEDIR" || exit 1

# Keep logs and saves inside the installed port directory.
: > "$GAMEDIR/log.txt"
exec > >(tee -a "$GAMEDIR/log.txt") 2>&1

export RE4_ROOT="$GAMEDIR"
export XDG_DATA_HOME="$CONFDIR"
# dArkOS exposes the native EGL loader through this name. Respect an existing
# CFW override, but do not set SDL_VIDEODRIVER or any screen rotation here.
export SDL_VIDEO_EGL_DRIVER="${SDL_VIDEO_EGL_DRIVER:-libEGL.so}"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-alsa}"
export SDL_GAMECONTROLLERCONFIG="${sdl_controllerconfig:-${SDL_GAMECONTROLLERCONFIG:-}}"
# Compatibility defaults for Mali-G31/EGL implementations. They reduce the
# requested framebuffer features without rotating or scaling the LCD.
export RE4_GL_MINIMAL="${RE4_GL_MINIMAL:-1}"
export RE4_GL_NO_STENCIL="${RE4_GL_NO_STENCIL:-1}"
export RE4_DESKTOP_GL="${RE4_DESKTOP_GL:-0}"
if [ -n "${DEVICE_NAME:-}" ]; then export DEVICE_NAME; fi

# Match the official PortMaster SDL/OpenGL launcher flow. The CFW-specific
# libgl file may select libgl4es/libGLESv1_CM and device EGL paths needed by
# Android Mobile GLES1 code; without it the host can run its frame loop while
# presenting only a blank surface.
set +u
if [ -f "${controlfolder}/libgl_${CFW_NAME:-}.txt" ]; then
    source "${controlfolder}/libgl_${CFW_NAME:-}.txt"
elif [ -f "${controlfolder}/libgl_default.txt" ]; then
    source "${controlfolder}/libgl_default.txt"
fi
set -u
# The original host was linked against GLIBC_2.38, while some dArkOSRE/dArkOSEN
# images expose an older /lib32. Prefer the self-contained ARMHF loader/runtime
# shipped in this experimental build, but keep system paths available for GLES,
# ALSA and other device libraries.
RUNTIME_DIR="$GAMEDIR/runtime/armhf"
ARMHF_LOADER=""
if [ -x "$RUNTIME_DIR/ld-linux-armhf.so.3" ] && [ -s "$RUNTIME_DIR/libc.so.6" ]; then
    ARMHF_LOADER="$RUNTIME_DIR/ld-linux-armhf.so.3"
    export LD_LIBRARY_PATH="$RUNTIME_DIR:$GAMEDIR/lib:${LD_LIBRARY_PATH:-}:/lib32:/usr/lib32:/lib:/usr/lib:/lib/arm-linux-gnueabihf:/usr/lib/arm-linux-gnueabihf"
else
    export LD_LIBRARY_PATH="$GAMEDIR/lib:${LD_LIBRARY_PATH:-}"
fi

# The host is an ARMHF ELF, but PortMaster may report the firmware/kernel
# environment as aarch64 even when 32-bit ARM execution is enabled. `PORT_32BIT=Y`
# is the PortMaster compatibility signal; do not reject the port solely because
# DEVICE_ARCH is not the literal string armhf. If the kernel lacks ARMHF support,
# the real exec status is logged below instead of showing a false preflight error.
printf 'device_arch_reported=%s\n' "${DEVICE_ARCH:-unset}"
printf 'port_32bit=%s\n' "${PORT_32BIT:-unset}"
printf 'armhf_loader=%s\n' "${ARMHF_LOADER:-system-loader}"
printf 'portmaster_gl_config=%s\n' "${controlfolder}/libgl_${CFW_NAME:-default}.txt"
printf 're4_gl_minimal=%s\n' "$RE4_GL_MINIMAL"
printf 're4_gl_no_stencil=%s\n' "$RE4_GL_NO_STENCIL"
printf 're4_desktop_gl=%s\n' "$RE4_DESKTOP_GL"

# The original upload carried real binary assets with an extra .png suffix.
# The release tree contains the actual names expected by FileManager.
required_files=(
    "re4_host"
    "lib/libbio4af.so"
    "lib/libmc_eruption_for_android_jni.so"
    "data/monhun/Acv_GmParam.bin"
    "data/monhun/Acv_Sound.bin"
    "data/monhun/Acv_Tex.h2z"
    "data/monhun/common.h2z"
    "data/monhun/Acv_3DBase.h2z"
    "data/monhun/Acv_3DChar.h2z"
    "data/monhun/Acv_3DStg01.h2z"
    "data/monhun/Acv_3DStg02.h2z"
    "data/monhun/Acv_3DStg03.h2z"
    "data/monhun/Acv_3DStg04.h2z"
    "data/monhun/Acv_3DStg05.h2z"
    "data/monhun/Acv_3DStg06.h2z"
    "data/monhun/Acv_3DStg07.h2z"
    "data/monhun/Acv_3DStg08.h2z"
    "data/monhun/Acv_3DStg09.h2z"
    "data/monhun/Acv_3DStg10.h2z"
    "data/monhun/Acv_3DStg11.h2z"
    "data/monhun/Acv_3DStg12.h2z"
    "data/monhun/Acv_3DStg13.h2z"
    "data/monhun/Acv_3DStg14.h2z"
    "data/monhun/Acv_3DStg15.h2z"
    "data/monhun/Acv_3DStg16.h2z"
    "data/monhun/Acv_3DStg17.h2z"
    "data/monhun/Acv_3DStg18.h2z"
    "data/monhun/Acv_3DStg19.h2z"
    "data/monhun/Acv_3DStg19_1.h2z"
    "data/monhun/Acv_3DStg20.h2z"
    "data/monhun/Acv_3DStg21.h2z"
    "data/monhun/Acv_3DStg22.h2z"
    "data/monhun/bio4.m4v"
    "data/monhun/buki.m4v"
    "data/monhun/ending.m4v"
    "data/monhun/res4.m4v"
    "data/monhun/eu_font_U16le.fnt"
    "data/monhun/jp_font_U16le.fnt"
    "runtime/armhf/ld-linux-armhf.so.3"
    "runtime/armhf/libc.so.6"
    "runtime/armhf/libm.so.6"
    "runtime/armhf/libstdc++.so.6"
    "runtime/armhf/libgcc_s.so.1"
)
missing=0
for rel in "${required_files[@]}"; do
    if [ ! -s "$GAMEDIR/$rel" ]; then
        echo "Resident Evil 4 Mobile: asset ausente ou vazio: $rel" >&2
        missing=1
    fi
done
if [ "$missing" -ne 0 ]; then
    if declare -F pm_message >/dev/null 2>&1; then pm_message "Dados do Resident Evil 4 Mobile estão incompletos. Veja log.txt."; fi
    exit 1
fi

# gptokeyb maps R36S buttons to the Android keycodes understood by this host.
# On a bare terminal, the game still starts without the optional mapper.
GPTK_PID=""
if [ -n "${GPTOKEYB:-}" ] && [ -f "$GAMEDIR/residentevil4.gptk" ]; then
    $GPTOKEYB "re4_host" -c "$GAMEDIR/residentevil4.gptk" &
    GPTK_PID=$!
fi

# PortMaster's platform helper restores device-specific display/audio state.
if declare -F pm_platform_helper >/dev/null 2>&1; then
    pm_platform_helper "$GAMEDIR/re4_host"
fi

cleanup() {
    if [ -n "$GPTK_PID" ] && kill -0 "$GPTK_PID" 2>/dev/null; then
        kill "$GPTK_PID" 2>/dev/null || true
    fi
    if declare -F pm_finish >/dev/null 2>&1; then
        pm_finish
    fi
}
trap cleanup EXIT INT TERM

if [ -n "$ARMHF_LOADER" ]; then
    "$ARMHF_LOADER" --library-path "$LD_LIBRARY_PATH" "$GAMEDIR/re4_host" "$GAMEDIR"
else
    "$GAMEDIR/re4_host" "$GAMEDIR"
fi
status=$?
exit "$status"
