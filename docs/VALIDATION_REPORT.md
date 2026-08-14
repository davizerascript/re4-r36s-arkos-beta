# Validação final do port Resident Evil 4 Mobile — R36S/ArkOS

## Veredito

A versão corrigida **resolveu o travamento que ocorria no primeiro frame**. O host ARMHF iniciou o Mascot Capsule e o game core, criou o contexto SDL/EGL/GLES, passou por `draw frame 0`, `draw frame 1` e `draw frame 2` e permaneceu estável durante os testes prolongados.

Com base nos testes realizados, minha estimativa é que o port tem **alta probabilidade de iniciar e apresentar imagem no R36S**. A probabilidade de o conjunto completo — imagem, áudio, controles, saves e retorno ao menu — funcionar sem ajustes é **boa, mas não absoluta**, porque o sandbox não possui o LCD, o chip gráfico, o alto-falante nem os botões físicos do seu aparelho.

| Área | Resultado da validação | Confiança atual |
|---|---|---:|
| Instalação e arquitetura | Pacote íntegro, host ARMHF hard-float e estrutura de port compatível | Alta |
| Inicialização do jogo | Mascot Capsule, game core, JNI e ciclo de vida iniciaram corretamente | Alta |
| Renderização | Primeiro frame passou sem SIGSEGV; milhares de frames foram processados | Alta para inicialização |
| Imagem no LCD do R36S | Não observada diretamente | Ainda não confirmada |
| Áudio SDL | Teste de 44.100 Hz, mono e buffer de 1.024 amostras passou | Alta para o caminho SDL |
| Áudio audível do jogo | Não foi possível ouvir no sandbox | Moderada |
| Controles | Eventos SDL KEYDOWN/KEYUP e conversão para códigos Android existem | Moderada |
| Mapeamento físico do R36S | Não foi possível pressionar os botões reais | Ainda não confirmado |
| Estabilidade | 60 segundos headless e sessão offscreen prolongada sem crash | Alta no ambiente emulado |
| Save/load e retorno ao EmulationStation | Não exercitados no hardware | Não confirmado |

## Teste de tela e renderização

A falha da versão anterior era um salto para endereço nulo durante o primeiro desenho, causado pelo símbolo `glHint` estar presente na tabela GLES, mas sem stub funcional no modo headless. Na versão corrigida, o símbolo foi implementado e o binário também contém os registros adicionais de `Graphics3D.getDpyFormat()` e `Parallax`.

A execução corrigida em modo headless, com desenho habilitado, durou 60 segundos e terminou com status 0:

```text
re4: draw frame 0
re4: draw frame 1
re4: draw frame 2
re4: session ended after 3729 frames
```

Também foi executada a rota SDL offscreen com bibliotecas ARMHF de EGL/GLES, sem `RE4_HEADLESS=1`. Essa execução passou pela criação de janela/contexto e processou aproximadamente 9.150 frames na sessão prolongada:

```text
re4: onSurfaceCreated returned
re4: onSurfaceChanged returned
re4: session ended after 9150 frames
```

Esse segundo teste é especialmente importante: ele não apenas chama stubs headless; ele exercita a criação de contexto gráfico SDL/EGL e o caminho de renderização GLES. Assim, **a chance de o jogo abrir e gerar imagem no R36S é alta**.

A ressalva é que o backend offscreen usa Mesa por software, enquanto o R36S usa o backend gráfico próprio do ArkOS. Portanto, ainda pode haver diferença de viewport, escala, cores, stencil ou compatibilidade específica do driver. Não há evidência de que o jogo continuará com tela preta, mas a imagem física do LCD não foi comprovada.

Os padrões `bars`, `grid` e `text` também iniciaram e desenharam sem falhar. Eles são diagnósticos do caminho de tela; não representam a imagem real do jogo.

## Teste de áudio

O teste de áudio do host corrigido terminou com sucesso:

```text
re4: audio test passed: 44100 Hz, 1 channels, 1024 samples
```

Isso confirma que a camada SDL conseguiu abrir um dispositivo lógico e aceitar o formato PCM esperado. A versão corrigida também inclui o arquivo `data/monhun/Acv_Sound.bin.png`, que estava ausente na versão anterior.

O resultado não comprova que o áudio foi ouvido, pois o teste foi executado com `SDL_AUDIODRIVER=dummy`. Portanto, a avaliação é a seguinte:

> **O caminho de áudio está tecnicamente preparado e o teste sintético passou. Há boa probabilidade de o tom funcionar no R36S, desde que o ALSA e o mixer do ArkOS estejam normais. A música, os efeitos e as cutscenes ainda precisam de confirmação no alto-falante ou fone.**

No R36S, o primeiro teste recomendado é `Test Audio Tone.sh`. Se o tom for audível, isso confirma o caminho SDL/ALSA básico. Em seguida, o jogo deve ser testado para verificar efeitos e música.

## Teste de controles

O binário usa `SDL_PollEvent` e trata eventos SDL de tecla pressionada e liberada. O loop encaminha esses eventos para as rotinas Android fake `onKeyDown` e `onKeyUp`, que são usadas pelo núcleo do jogo.

A rotina de conversão de teclas contém códigos para as direções e para ações auxiliares. O log interno também registra um evento de teste:

```text
re4: test key 19 down/up
```

Isso prova que existe uma ponte funcional entre o sistema de entrada e o código Android do jogo. A avaliação por controle é:

| Controle | Avaliação |
|---|---|
| D-pad | **Boa probabilidade de funcionamento**; os códigos direcionais estão contemplados |
| A/B/X/Y | **Provável**, mas a ação exata de cada botão depende do mapeamento SDL do ArkOS |
| L/R | Há códigos auxiliares no conversor, mas não foram pressionados fisicamente |
| Start/Select/FN | Podem depender do launcher e dos atalhos definidos na imagem ArkOS |
| Pressionar e segurar | Não foi possível validar sem o aparelho |
| Repetição de direção | Não foi possível validar sem o aparelho |

Em outras palavras, **o caminho de controles está implementado**, não sendo um port sem entrada. O que permanece incerto é apenas o mapeamento físico final dos botões do R36S e se todas as ações do jogo estão associadas às teclas corretas.

## Estabilidade e jogabilidade provável

O núcleo passou pela inicialização JNI, `onCreate`, `onResume`, `onSurfaceCreated` e `onSurfaceChanged`. A versão corrigida não apresentou segmentation fault no primeiro frame nem durante os testes prolongados.

Isso representa uma mudança de estado importante em relação à versão anterior: o port deixou de ser apenas um executável que carregava os dados e travava imediatamente. Agora ele **inicializa o núcleo, entra no ciclo de desenho e permanece processando frames**.

Ainda não é possível afirmar que a campanha completa esteja jogável. Não foram confirmados diretamente no hardware:

| Item pendente | Motivo |
|---|---|
| Movimento com D-pad | Ausência de controle físico no sandbox |
| Ações, menus e combate | Necessidade de pressionar A/B/X/Y e observar a resposta do jogo |
| Áudio do jogo | Ausência de alto-falante/fone físico |
| Cutscenes | Dependem do caminho de vídeo e dos dados proprietários |
| Save/load | Não houve sessão física para criar e recarregar um save |
| Retorno ao EmulationStation | Depende do comportamento do launcher no ArkOS real |

## Compatibilidade provável com ArkOS

A estrutura do pacote é adequada ao modelo de instalação do ArkOS: a pasta inteira `Resident Evil 4 Mobile` deve ser copiada para `/roms/ports/`. O launcher calcula o próprio diretório, não depende do caminho do sandbox e não força `libGL.so.1`, evitando desviar o backend GLES nativo do aparelho.

O carregador também possui fallbacks para variantes versionadas das bibliotecas EGL/GLES, o que melhora a compatibilidade com diferentes imagens ArkOS. O host é ARMHF hard-float, compatível com a arquitetura normalmente usada no R36S.

## Instruções finais para o teste no R36S

Copie a pasta completa `Resident Evil 4 Mobile` para `/roms/ports/`. Não copie somente `re4_host`: os diretórios `lib/`, `data/monhun/`, `save/` e os scripts precisam permanecer juntos.

Execute na seguinte ordem:

1. `Test Audio Tone.sh`: confirme se o tom de 440 Hz é ouvido.
2. `Test Screen Bars.sh`: verifique se a tela acende e mostra as faixas de cor.
3. `Test Screen Grid.sh`: verifique se a grade não está deformada ou cortada.
4. `Test Screen Text.sh`: confirme contraste e atualização estável.
5. `Resident Evil 4 Mobile.sh`: aguarde pelo menos um minuto e teste D-pad, A/B/X/Y, L/R e Start/B.

Se o jogo iniciar com imagem, responder ao D-pad e aos botões principais e emitir áudio, então esta versão pode ser considerada **funcional na prática**. Se a tela ficar preta, o teste de barras e grade ajudará a separar problema do LCD/driver de problema do jogo.

## Classificação final

**Classificação recomendada: provavelmente jogável no R36S, com alta confiança de inicialização e renderização, confiança moderada em áudio e controles e confirmação física ainda necessária para o conjunto completo.**

A versão corrigida merece ser testada no aparelho. Diferentemente da versão anterior, há evidência técnica suficiente para dizer que **não deve mais travar no primeiro frame** e que **há uma probabilidade real de mostrar a imagem do jogo** no R36S/ArkOS.
