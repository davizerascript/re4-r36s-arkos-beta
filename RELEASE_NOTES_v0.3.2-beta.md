# Resident Evil 4 Mobile — v0.3.2-beta

## Correção principal

O teste físico no **dArkOSRE** e no **dArkOSEN** exibiu “Este port requer ARMHF.” antes de o jogo iniciar. A causa era uma barreira do launcher que comparava literalmente `DEVICE_ARCH` com `armhf`. Algumas imagens PortMaster podem informar `DEVICE_ARCH=aarch64` mesmo quando oferecem o caminho de execução de ports 32-bit.

O launcher agora mantém `PORT_32BIT=Y`, registra o valor de `DEVICE_ARCH` para diagnóstico e não aborta apenas por essa string. O host continua sendo um executável ARMHF 32-bit; se o firmware não possuir compatibilidade de execução ARMHF, o erro real de execução será registrado em `residentevil4/log.txt`.

## O que não mudou

A correção não converte o binário para AArch64, não modifica DTB, boot.ini, EGL ou GLES e não altera o mapeamento de controles. A orientação lógica continua horizontal em 640×480, sem rotação forçada.

## Validação

`bash -n` passou no launcher, `port.json` passou no parser JSON, o ZIP foi reextraído com sucesso e um fixture com `DEVICE_ARCH=aarch64` confirmou `RE4_ARCH_GATE_TEST=PASS`: o host foi chamado, `PORT_32BIT=Y` foi preservado e a mensagem falsa não apareceu.

A validação física do gameplay, vídeo, áudio, controles e retorno ao EmulationStation continua pendente no mesmo aparelho.

## Artefato

```text
Resident-Evil-4-Mobile-R36S-dArkOS-PortMaster-fixed-v0.3.2.zip
SHA-256: 4802981d3d12fdb61a9066d4715fdd2c9f447fbd0985587068ea8b6c119011be
```
