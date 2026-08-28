Resident Evil 4 Mobile — PortMaster/dArkOS R36S

Instalação:

1. Extraia o conteúdo deste arquivo diretamente para `/roms/ports/` na partição EASYROMS.
2. Confirme que os caminhos resultantes são `/roms/ports/Resident Evil 4 Mobile.sh` e `/roms/ports/residentevil4/`.
3. Reinicie ou atualize a lista de ports no EmulationStation e execute `Resident Evil 4 Mobile`.

Este pacote contém um host ARMHF 32-bit experimental. A partir da revisão v0.3.2, o launcher usa o sinal `PORT_32BIT=Y` do PortMaster e não bloqueia mais o valor `DEVICE_ARCH=aarch64` informado por algumas imagens dArkOSRE/dArkOSEN; isso remove a mensagem falsa “Este port requer ARMHF”. O host continua precisando que o firmware tenha suporte de execução ARMHF 32-bit. LCD, controles, áudio, vídeos, saves, desempenho sustentado e retorno ao EmulationStation precisam ser confirmados no R36S com a imagem específica do usuário.

Não copie somente o executável. Não renomeie os arquivos dentro de `residentevil4/data/monhun/`: os nomes `.h2z`, `.bin`, `.m4v` e `.fnt` são as extensões de dados do engine.

Para detalhes técnicos, veja `residentevil4/README.md`, `residentevil4/port.json` e `residentevil4/licenses/PROVENANCE_AND_REDIStribution_NOTICE.txt`.
