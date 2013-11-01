Deliberatório
=============

O Deliberatório é um jogo de cartas que simula o processo de discussão e deliberação das proposições na Câmara dos Deputados.

Site do projeto: http://deliberatorio.com.br/

Documentação: http://deliberatorio.com.br/doc


Entendendo a estrutura dos diretórios e arquivos:

./deliberatorio.sh - Script para gerar o CSV com pauta atual da Câmara dos Deputados e dados essenciais dos cartões;
./event.csv - Base das cartas especiais dos eventos;
./LICENSE - Licenciamento
./README.md - Este arquivo
./templates/ - Diretório com o template dos cartões
   dep.svg - Template do cartão para Deputados
   event.svg - Template do cartão para Eventos
   org.svg - Template do cartão para Órgãos
   prop.svg - Template do cartão para Proposições
   fotos/ - Diretório com foto dos Deputados (atualizado via API da Câmara dos Deputados)
   icones/ - Diretório com icones utilizado nas cartas
   partidos/ - Diretório com logos dos Partidos Brasileiros


Dependências:

- xmlstarlet - conjunto de ferramentas XML de linha de comandos, <http://xmlstar.sourceforge.net/>
- Inkscape - software para edição vertorial SVG, <http://www.inkscape.org>
- InkscapeGenerator - extensão para Inkscape gerar mala direta, <http://wiki.colivre.net/Aurium/InkscapeGenerator>


Como instalar/gerar os cartões?

Ao instalar as dependêncais necessárias, rode o script "deliberatorio.sh" para gerar um CSV das atividades atuais que estão pautada para esta próxima semana na Câmara dos Deputados.

O próximo passo é abrir o Inkscape com a extensão Generator funcionando, seguir a documentação para apontar os arquivos .csv gerados aos respectivos templates .svg,  ambos tem o mesmo nome, são eles:

- dep.svg -> dep.csv
- event.svg -> event.csv
- org.svg -> org.csv
- prop.svg -> prop.csv

O resultado será vários cards em .PDF individuais, você pode usar o "pdfjoin" para juntar todos PDFs em um único arquivo de impressão, dispondo lado-lado, a quantidade X por folha A3 ou A4.

