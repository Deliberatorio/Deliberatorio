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

#### Dependências:

- xmlstarlet - conjunto de ferramentas XML de linha de comandos, <http://xmlstar.sourceforge.net/>
- Inkscape - software para edição vertorial SVG, <http://www.inkscape.org>
- PDFJam - scripts para tratamento de PDF <http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam>

#### Como instalar/gerar os cartões?

Após instalar as dependêncais necessárias, rode o script "deliberatorio.sh".

Aguarde a execução do script e pronto. O tempo de execução pode variar dependendo da sua velocidade de conexão à internet, pois são obtidos sempre os dados mais recentes da Câmara dos Deputados.

Em seguida você irá encontrar no diretório raiz dois arquivos PDF para imprimir o jogo indicando o tamanho das cartas e a data em que foi gerado:

    Deliberatorio_16xA4_DATA.pdf
    Deliberatorio_9XA4_DATA.pdf

Corte as cartas, leia as instruções e bom jogo!


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

