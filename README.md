# Resta-Dois
> O Resta Dois é um jogo muito parecido com seu primo Resta Um, porém o objetivo é fazer sobrar duas peças no tabuleiro ao invés de apenas uma. Todos detalhes de implementação estão no pdf contido nesse mesmo repositório. Este README consiste apenas em uma pequena ilustração do projeto.

# Regras do jogo
> O tabuleiro do jogo consiste em um cruz que começa com uma posição vazia no centro.

![List directory](https://github.com/medina325/Resta-Dois/blob/main/images/tabuleiro.jpg?raw=true)

> Assim como o jogo de dama, para eliminar uma peça do tabuleiro deve-se saltar sobre ela, logo sempre há 4 possibilidades no início do jogo: saltar a peça da esquerda para direita, da direita para esquerda, de cima para baixo ou de baixo para cima.

> Como não foi usado nenhum periférico externo em conjunto com a plataforma de desenvolvimento em FPGA usada (Cyclone IV), a jogabilidade acabou sendo um tanto quanto prejudicada, sendo pouco intuitiva.

<img id="cyclone" src="https://www.dhresource.com/0x0/f2/albu/g5/M00/5A/63/rBVaI1nDK4mAOr-LAAdEFp_RNEA674.jpg" alt="Plataforma Cyclone IV">

> Para mover uma peça é necessário definir com as coordenadas iniciais e finais de uma dada jogada (como dito antes mais detalhes no pdf que descreve o projeto).

> Obviamente, o estado final do tabuleiro poderá ser apenas dois: vitória ou derrota, dependendo da quantidade de peças remanescentes no tabuleiro.

![List directory](https://github.com/medina325/Resta-Dois/blob/main/images/win_display.jpg?raw=true)

![List directory](https://github.com/medina325/Resta-Dois/blob/main/images/lose_display.jpg?raw=true)

---
<style>
    img {
        height: 50px;
        display: block;
        margin-left: auto;
        margin-right:auto;
    }
    #cyclone {
        height: 200px;
    }
</style>