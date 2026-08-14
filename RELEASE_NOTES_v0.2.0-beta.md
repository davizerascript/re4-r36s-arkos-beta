# Resident Evil 4 Mobile — R36S/ArkOS v0.2.0-beta

## Aviso

Esta é uma **versão beta experimental** para testes comunitários no R36S com ArkOS. Ela não deve ser tratada como uma versão final. Faça backup do cartão e mantenha os arquivos de log caso algo falhe.

## O que foi corrigido

A beta inclui a correção do stub GLES `glHint`, que provocava um salto para endereço nulo no primeiro frame da versão anterior. Também foram incluídos os métodos fake JNI de `Graphics3D.getDpyFormat()` e `Parallax`, ajustes nas strings e assinaturas da JavaVM fake, fallbacks para nomes versionados de EGL/GLES, launcher sem forçar `libGL.so.1` e o asset `Acv_Sound.bin.png`.

## O que foi testado

O host ARMHF iniciou o Mascot Capsule, carregou o game core e passou pelos callbacks de ciclo de vida Android fake. Em modo headless com desenho habilitado, passou por `draw frame 0`, `draw frame 1` e `draw frame 2`, processando 3.729 frames em uma sessão de 60 segundos sem segmentation fault. Em SDL offscreen com EGL/GLES ARMHF, sem o modo headless, também processou milhares de frames sem o travamento de renderização anterior.

O teste sintético de áudio passou com 44.100 Hz, um canal e buffer de 1.024 amostras. Esse resultado valida o caminho lógico SDL, mas o volume e a reprodução física no alto-falante ou fone precisam ser confirmados no R36S.

## O que ainda precisa ser confirmado

A imagem no LCD real, o mapeamento exato dos botões físicos, áudio audível, música, efeitos, cutscenes, save/load e retorno limpo ao EmulationStation não foram validados diretamente no hardware. O comportamento pode variar entre versões do ArkOS e drivers gráficos disponíveis no cartão.

## Créditos

Port beta e arquivos disponibilizados por **[@melo._.071](https://www.instagram.com/melo._.071/)**.

## Identificação do arquivo

```text
Nome: Resident-Evil-4-Mobile-R36S-ArkOS-BETA-v0.2.0.zip
SHA-256: aa0d02e42caa1494c60c77b1425735a262b41af47f2e19e2ad7617f7b5b5e239
```
