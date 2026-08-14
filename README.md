# Resident Evil 4 Mobile — R36S/ArkOS Beta

> **Versão BETA para testes.** Este pacote é experimental e foi preparado para avaliação no R36S com ArkOS. Faça backup do cartão antes da instalação e relate qualquer falha com o modelo da imagem ArkOS, o log e uma descrição do comportamento observado.

## Download completo

Baixe o arquivo completo na seção [Releases](../../releases). O ZIP inclui o port inteiro: executável ARMHF, bibliotecas nativas, dados do jogo, arquivo de áudio, scripts de diagnóstico, diretório de save e documentação.

**Arquivo da beta:** `Resident-Evil-4-Mobile-R36S-ArkOS-BETA-v0.2.0.zip`  
**SHA-256:** `aa0d02e42caa1494c60c77b1425735a262b41af47f2e19e2ad7617f7b5b5e239`  
**Tamanho:** aproximadamente 95,7 MB

## Instalação

Extraia o ZIP e copie a pasta completa `Resident Evil 4 Mobile` para a pasta de ports da partição `EASYROMS`, normalmente:

```text
/roms/ports/
```

Não copie somente o executável. Os diretórios `lib/`, `data/monhun/`, `save/` e os scripts precisam permanecer dentro da pasta do port. Depois, abra o menu **Ports** do ArkOS e execute `Resident Evil 4 Mobile.sh`.

## Testes recomendados

Para separar problemas de áudio, tela e jogo, execute primeiro os testes incluídos:

| Script | Finalidade |
|---|---|
| `Test Audio Tone.sh` | Testa o caminho SDL/ALSA e o alto-falante ou fone |
| `Test Screen Bars.sh` | Testa cores, orientação e preenchimento da tela |
| `Test Screen Grid.sh` | Testa escala e deformação do viewport 640×480 |
| `Test Screen Text.sh` | Testa contraste e atualização do framebuffer |
| `Resident Evil 4 Mobile.sh` | Inicia o jogo beta |

No jogo, teste o D-pad, A/B/X/Y, L/R, Start e B. Aguarde pelo menos um minuto para verificar estabilidade, áudio e resposta dos controles.

## Estado conhecido da beta

A versão corrigida passou pelo primeiro frame e por testes prolongados no host ARMHF. Em ambiente de teste com SDL/EGL/GLES, o núcleo iniciou, criou o contexto gráfico e processou milhares de frames sem o travamento de renderização observado na versão anterior. O teste sintético de áudio também passou em 44.100 Hz, mono, com buffer de 1.024 amostras.

A validação física completa ainda depende do R36S real. Em particular, o LCD/driver Mali, o áudio audível, o mapeamento físico dos botões, os saves, as cutscenes e o retorno ao EmulationStation podem variar conforme a imagem ArkOS instalada. Por isso, esta publicação deve ser tratada como **beta de teste**, não como uma versão final.

## Relato de problemas

Ao relatar uma falha, informe a versão exata do ArkOS, se a falha ocorreu nos testes de tela, no teste de áudio ou no jogo, e o último texto exibido no log. Se possível, inclua uma fotografia ou screenshot da tela, sem enviar o cartão inteiro nem dados pessoais.

## Créditos

Créditos pelo port beta e pela disponibilização dos arquivos: **Instagram [@melo._.071](https://www.instagram.com/melo._.071/)**.

Este repositório é mantido para facilitar o teste comunitário da versão beta no R36S/ArkOS. Não representa uma versão oficial de Resident Evil 4 nem possui vínculo com a Capcom.

## Licença e distribuição

Os arquivos deste repositório e da release são disponibilizados conforme a autorização do responsável pelo port beta. Não remova os créditos, não apresente o projeto como oficial e respeite os direitos dos titulares dos componentes originais do jogo.
