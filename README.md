# Resta-Dois
> O Resta Dois é um jogo muito parecido com seu primo Resta Um, porém o objetivo é fazer sobrar duas peças no tabuleiro ao invés de apenas uma. Todos detalhes de implementação estão no pdf contido nesse mesmo repositório. Este README consiste apenas em uma pequena ilustração do projeto.

## Regras do jogo
> O tabuleiro do jogo consiste em um cruz que começa com uma posição vazia no centro.

<p align="center">
  <img width="460" height="360" src="https://github.com/medina325/Resta-Dois/blob/main/images/tabuleiro.jpg?raw=true" alt="tabuleiro">
</p>

> Assim como o jogo de dama, para eliminar uma peça do tabuleiro deve-se saltar sobre ela, logo sempre há 4 possibilidades no início do jogo: saltar a peça da esquerda para direita, da direita para esquerda, de cima para baixo ou de baixo para cima.

> Como não foi usado nenhum periférico externo em conjunto com a plataforma de desenvolvimento em FPGA usada (Cyclone IV), a jogabilidade acabou sendo um tanto quanto prejudicada, sendo pouco intuitiva.

<p align="center">
  <img width="460" height="360" src="https://www.dhresource.com/0x0/f2/albu/g5/M00/5A/63/rBVaI1nDK4mAOr-LAAdEFp_RNEA674.jpg" alt="Plataforma Cyclone IV">
</p>

> Para mover uma peça é necessário definir com as coordenadas iniciais e finais de uma dada jogada (como dito antes mais detalhes no pdf que descreve o projeto).

> Obviamente, o estado final do tabuleiro poderá ser apenas dois: vitória ou derrota, dependendo da quantidade de peças remanescentes no tabuleiro. Sendo que ambas mensagens de vitória ou derrota são informadas pelo display de 7 segmentos como mostrado abaixo.

### Vitória :D
<p align="center">
  <img id="cyclone" width="100" height="50" src="https://github.com/medina325/Resta-Dois/blob/main/images/win_display.jpg?raw=true" alt="win_display">
</p>

### Derrota :(
<p align="center">
  <img id="cyclone" width="100" height="50" src="https://github.com/medina325/Resta-Dois/blob/main/images/lose_display.jpg?raw=true" alt="lose_display">
</p>
