#!/bin/bash

#   Deliberatório - Script para gerar os dados para carta do jogo
#   Copyright (C) 2013 Valessio Brito <contato@valessiobrito.com.br>
#                      Luciano Santa Brígida <lucianosb@sbvirtual.com.br>
#
#   Este arquivo é parte do programa Deliberatório. O Deliberatório é um
#   software livre; você pode redistribuí-lo e/ou modificá-lo dentro dos termos
#   da GNU General Public License como publicada pela Fundação do Software Livre
#   (FSF); na versão 3 da Licença. Este programa é distribuído na esperança que
#   possa ser útil, mas SEM NENHUMA GARANTIA; sem uma garantia implícita de
#   ADEQUAÇÃO a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a licença para
#   maiores detalhes. Você deve ter recebido uma cópia da GNU General Public License,
#   sob o título "LICENCA.txt", junto com este programa, se não, acesse
#   http://www.gnu.org/licenses/
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   Version 0.1

URL_ORGAOS="http://www.camara.gov.br/SitCamaraWS/Orgaos.asmx/ObterOrgaos"
CSV_ORGAOS="$PWD/all-org.csv"
CSV_CARDORG="$PWD/org.csv"
TMP_ORGAOS=$( mktemp )

CSV_PAUTAS="$PWD/prop.csv"
TMP_PAUTAS=$( mktemp )

URL_DEPUTADOS="http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados"
CSV_DEPUTADOS="$PWD/all-dep.csv"
CSV_CARDDEP="$PWD/dep.csv"
TMP_DEPUTADOS=$( mktemp )
TMP_DETALHES=$( mktemp )

# Limpa dados anteriores
rm -i $CSV_ORGAOS $CSV_PAUTAS $CSV_DEPUTADOS $CSV_CARDORG $CSV_CARDDEP

# OBTER ORGAOS
wget $URL_ORGAOS -O $TMP_ORGAOS
COUNT=0
TOTAL=`cat $TMP_ORGAOS | wc -l`
ProgBar="[=======================================================================]"

echo "

    Obtendo Pauta da Semana:"

for idOrgao in `xmlstarlet sel -t -v "//orgaos/orgao/@id" $TMP_ORGAOS` ; do
    let COUNT++

    # Parse no XML da sigla e descrição do Orgão
    siglaOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@sigla" $TMP_ORGAOS)
    descricaoOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@descricao" $TMP_ORGAOS)

    # Plotando no CSV dos Orgãos
    echo $idOrgao\;$siglaOrgao\;$descricaoOrgao >> $CSV_ORGAOS

    # OBTER PAUTAS
    URL_PAUTAS="http://www.camara.gov.br/SitCamaraWS/Orgaos.asmx/ObterPauta?IDOrgao=$idOrgao&datIni=$(date +%d\/%m\/%Y)&datFim=$(date +%d\/%m\/%Y -d "+10 days")"
    wget $URL_PAUTAS -O $TMP_PAUTAS 2> /dev/null
    PautaCOUNT=0

    # Progresso da Pauta
    ProgPauta=$(( $COUNT * 73 / $TOTAL ))
    printf "\r%3d.%1d%% %.${ProgPauta}s" $(( $COUNT * 100 / $TOTAL )) $(( ($COUNT * 1000 / $TOTAL) % 10 )) $ProgBar

    # Obter detalhes da Pauta
    for idPauta in `xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao/sigla" $TMP_PAUTAS | sed s/\ /_/g` ; do
        let PautaCOUNT++
        ementaPauta=$(xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao[$PautaCOUNT]/ementa" $TMP_PAUTAS)
        pontoPauta=$(echo $idPauta | rev | cut -c -2 | rev)
        nomePauta=$(echo $idPauta | sed s/"\/"/":"/g)
        echo $pontoPauta\;$(echo $idPauta | sed s/_/\ /g)\;$siglaOrgao\;$ementaPauta\;$nomePauta \
            | grep -E 'PL_|PEC_' \
            | grep -vE '(Altera|nova redação|revoga|Acrescenta|REQ_)'
    done | head -5 >> $CSV_PAUTAS

done # End idOrgaos

echo "

    Obtenção das pautas, finalizado.

"

# OBTER DEPUTADOS
wget $URL_DEPUTADOS -O $TMP_DEPUTADOS
COUNT=0
TOTAL=`cat $TMP_DEPUTADOS | wc -l`

echo "

    Obtendo Deputados:"

for ideCadastro in `xmlstarlet sel -t -v "//deputados/deputado/ideCadastro" $TMP_DEPUTADOS` ; do
    let COUNT++

    # Parser XML dos detalhes do Deputado
    nomeParlamentar=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/nomeParlamentar" $TMP_DEPUTADOS)
    partidoDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/partido" $TMP_DEPUTADOS)
    ufDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/uf" $TMP_DEPUTADOS)
    urlFoto=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/urlFoto" $TMP_DEPUTADOS)
    sexoDep=$(xmlstarlet sel -t -v "/deputados/deputado[$COUNT]/sexo" $TMP_DEPUTADOS)

    # Capturando detalhe do deputado no orgão
    URL_DETALHE="http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=$ideCadastro&numLegislatura="
    siglaDeputado=$(lynx -source "$URL_DETALHE" | xmlstarlet sel -t -v "//Deputados/Deputado/comissoes/comissao[last()]/siglaComissao" | uniq)

    # Gerando CSV dos Deputados
    echo $ideCadastro\;$nomeParlamentar\;$partidoDeputado\;$ufDeputado\;$siglaDeputado\;$urlFoto\;$sexoDep >> $CSV_DEPUTADOS

    # Progresso dos Deputados
    ProgDeputado=$(( $COUNT * 73 / $TOTAL ))
    printf "\r%3d.%1d%% %.${ProgPauta}s" $(( $COUNT * 100 / $TOTAL )) $(( ($COUNT * 1000 / $TOTAL) % 10 )) $ProgBar

done #ideCadastro

echo "

Deputados obtidos com sucesso.

"

# Gera lista de Orgaos na Pauta
listOrgPauta=`cat $CSV_PAUTAS | cut -d";" -f 3| sort | uniq`

echo "Gerando CSV dos cartões para o jogo."
# Função para Gerar CSV na Pauta
function gerar_cards {
for cardOrgao in $listOrgPauta; do
    grep $cardOrgao $1
done > $2
}

# Gera CSV de Orgaos e Deputados na Pauta
gerar_cards $CSV_ORGAOS $CSV_CARDORG
gerar_cards $CSV_DEPUTADOS $CSV_CARDDEP

echo "Todos os CSV para o jogo foram gerados, agora use o InkscapeGenerator para gerar os cartões."
