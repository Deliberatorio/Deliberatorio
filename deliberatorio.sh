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

# LIMPA
rm -i $CSV_ORGAOS
rm -i $CSV_PAUTAS
rm -i $CSV_DEPUTADOS

# OBTER ORGAOS
wget $URL_ORGAOS -O $TMP_ORGAOS 2> /dev/null
COUNT=0
for idOrgao in `xmlstarlet sel -t -v "//orgaos/orgao/@id" $TMP_ORGAOS` ; do
    let COUNT++
    siglaOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@sigla" $TMP_ORGAOS | sed s/\ //g)
    descricaoOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@descricao" $TMP_ORGAOS)

    echo $idOrgao\;$siglaOrgao\;$descricaoOrgao >> $CSV_ORGAOS

    #OBTER PAUTAS
    URL_PAUTAS="http://www.camara.gov.br/SitCamaraWS/Orgaos.asmx/ObterPauta?IDOrgao=$idOrgao&datIni=$(date +%d\/%m\/%Y)&datFim=$(date +%d\/%m\/%Y -d "+10 days")"
    wget $URL_PAUTAS -O $TMP_PAUTAS 2> /dev/null
    PautaCOUNT=0

    # Obter detalhes da Pauta
    for idPauta in `xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao/sigla" $TMP_PAUTAS | sed s/\ /_/g` ; do
        let PautaCOUNT++
        ementaPauta=$(xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao[$PautaCOUNT]/ementa" $TMP_PAUTAS)
        pontoPauta=$(echo $idPauta | rev | cut -c -2 | rev)
        nomePauta=$(echo $idPauta | sed s/\//:/g)
        echo $pontoPauta\;$idPauta\;$siglaOrgao\;$ementaPauta\;$nomePauta \
            | grep -E 'PL_|PEC_' \
            | grep -vE '(Altera|nova redação|revoga|Acrescenta|REQ_)'
    done | head -5 >> $CSV_PAUTAS

done # End idOrgaos

# OBTER DEPUTADOS
wget $URL_DEPUTADOS -O $TMP_DEPUTADOS 2> /dev/null
COUNT=0
for ideCadastro in `xmlstarlet sel -t -v "//deputados/deputado/ideCadastro" $TMP_DEPUTADOS` ; do
    let COUNT++
    nomeParlamentar=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/nomeParlamentar" $TMP_DEPUTADOS)
    partidoDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/partido" $TMP_DEPUTADOS)
    ufDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/uf" $TMP_DEPUTADOS)
    urlFoto=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/urlFoto" $TMP_DEPUTADOS)
    sexoDep=$(xmlstarlet sel -t -v "/deputados/deputado[$COUNT]/sexo" $TMP_DEPUTADOS)

    # VER DETALHES DEPUTADO
    URL_DETALHES="http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=$ideCadastro&numLegislatura="
    wget $URL_DETALHES -O $TMP_DETALHES 2> /dev/null
    DetalhesCOUNT=0

    for idOrgaoCD in `xmlstarlet sel -t -v "//Deputados/Deputado/comissoes/comissao/idOrgaoLegislativoCD" $TMP_DETALHES` ; do
        let DetalhesCOUNT++
        siglaDeputado=$(xmlstarlet sel -t -v "//Deputados/Deputado/comissoes/comissao[last()]/siglaComissao" $TMP_DETALHES)

    done
    echo $ideCadastro\;$nomeParlamentar\;$partidoDeputado\;$ufDeputado\;$siglaDeputado\;$urlFoto\;$sexoDep
done >> $CSV_DEPUTADOS

# Gera cards para Orgaos somente na Pauta
for cardOrgao in `cat $CSV_PAUTAS | cut -d";" -f 3| sort | uniq`; do
    grep $cardOrgao $CSV_ORGAOS
done > $CSV_CARDORG

# Gerar cards para Deputados somente na Pauta
for cardOrgao in `cat $CSV_PAUTAS | cut -d";" -f 3| sort | uniq`; do
    grep $cardOrgao $CSV_DEPUTADOS
done > $CSV_CARDDEP

