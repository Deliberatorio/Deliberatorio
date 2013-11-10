Deliberatório
=============

O Deliberatório é um jogo de cartas que simula o processo de discussão e deliberação das proposições na Câmara dos Deputados.

Site do projeto: http://deliberatorio.com.br/

Documentação: http://deliberatorio.com.br/doc


Entendendo a estrutura dos diretórios e arquivos:

- ./deliberatorio.sh - Script para gerar o CSV com pauta atual da Câmara dos Deputados e dados essenciais dos cartões;
- ./event.csv - Base das cartas especiais dos eventos;
- ./LICENSE - Licenciamento
- ./README.md - Este arquivo
- ./templates/ - Diretório com o template dos cartões
  - cards_padrao/dep.svg - Template do cartão para Deputados no tema Padrão
  - cards_padrao/event.svg - Template do cartão para Eventos no tema Padrão
  - cards_padrao/org.svg - Template do cartão para Órgãos no tema Padrão
  - cards_padrao/prop.svg - Template do cartão para Proposições no tema Padrão
  - fotos/ - Diretório com foto dos Deputados (atualizado via API da Câmara dos Deputados)
  - icones/ - Diretório com icones utilizado nas cartas
  - partidos/ - Diretório com logos dos Partidos Brasileiros
  - cards_???? - Diretório com outra proposta de tema para as cartas

#### Dependências:

- xmlstarlet - conjunto de ferramentas XML de linha de comandos, <http://xmlstar.sourceforge.net/>
- Inkscape - software para edição vertorial SVG, <http://www.inkscape.org>

#### Como instalar/gerar os cartões?

Ao instalar as dependêncais necessárias, rode o script "deliberatorio.sh" para gerar um CSV das atividades atuais que estão pautada para esta próxima semana na Câmara dos Deputados.

O próximo passo é abrir o Inkscape com a extensão Generator funcionando, seguir a documentação para apontar os arquivos .csv gerados aos respectivos templates .svg,  ambos tem o mesmo nome, são eles:

- dep.svg -> dep.csv
- event.svg -> event.csv
- org.svg -> org.csv
- prop.svg -> prop.csv

O resultado será vários cards em .PDF individuais, você pode usar o "pdfjoin" para juntar todos PDFs em um único arquivo de impressão, dispondo lado-lado, a quantidade X por folha A3 ou A4.

    # Gera arquivo pdf com cada um PDF gerado em uma folha. 
    # Ao imprimir escolha imprimir 16 ou 9 por folha no seu software de impressão favorito
    pdjoin ~/DIRETORIO/*.pdf --outfile deliberatorio.pdf


#### Sobre os Branchs:

- master - Versão Estável do Script para gerar o baralho;
- scripts-web - Versão em desenvolvimento da aplicação Web;

---

### Licença GPL V3

Leia o [texto integral da licença](https://github.com/sbvirtual/deliberatorio/blob/master/LICENSE)

    
    Este programa é um software livre; você pode redistribuí-lo e/ou 

    modificá-lo dentro dos termos da Licença Pública Geral GNU como 

    publicada pela Fundação do Software Livre (FSF); na versão 3 da 

    Licença, ou superior.



    Este programa é distribuído na esperança de que possa ser útil, 

    mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a qualquer

    MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a

    Licença Pública Geral GNU para maiores detalhes.



    Você deve ter recebido uma cópia da Licença Pública Geral GNU

    junto com este programa, se não, escreva para a Fundação do Software

    Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

