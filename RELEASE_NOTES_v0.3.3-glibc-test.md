# Resident Evil 4 Mobile — v0.3.3-glibc-test

Build experimental criada após o teste físico em dArkOSRE/dArkOSEN retornar `GLIBC_2.38 not found` para `/lib32/libc.so.6` e `/lib32/libm.so.6`.

Esta revisão inclui um runtime ARMHF local com `ld-linux-armhf.so.3`, `libc.so.6`, `libm.so.6`, `libstdc++.so.6` e `libgcc_s.so.1`. O launcher usa o runtime local quando disponível, mantém `PORT_32BIT=Y` e não bloqueia mais um firmware apenas porque `DEVICE_ARCH` informa `aarch64`.

As bibliotecas GLES, áudio ALSA e componentes específicos do hardware continuam sendo fornecidos pelo firmware. O runtime local resolve a dependência de glibc do host, mas não transforma o executável em AArch64.

A validação local confirmou que o erro `GLIBC_2.38 not found` desapareceu e que o host avançou até a dependência gráfica `libGL.so.1` no ambiente QEMU. Gameplay, áudio, vídeo, controles e retorno ao EmulationStation ainda precisam de teste no R36S.

```text
SHA-256: bb99c9f0de965db2c10fcc0e4740b74919da70a39c9c471d81bb53dc2c6aa99c
```
