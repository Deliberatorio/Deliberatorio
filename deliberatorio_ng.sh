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

#   Version NG 0.1 (Versão Nova Geração em Desenvolvimento)

CSV_ORGAOS="$PWD/all-org.csv"
CSV_CARDORG="$PWD/org.csv"
TMP_ORGAOS="data/ObterOrgaos.xml"

CSV_PAUTAS="$PWD/prop.csv"
TMP_PAUTAS=$( mktemp )

CSV_DEPUTADOS="$PWD/all-dep.csv"
CSV_CARDDEP="$PWD/dep.csv"
TMP_DEPUTADOS="data/ObterDeputados.xml"

# Barra de Progresso
COUNT=0

function progresso {
   TOTAL=$1
   ProgBar="[=======================================================================]"
   ProgCount=$(( $COUNT * 73 / $TOTAL ))
   printf "\r%3d.%1d%% %.${ProgCount}s" $(( $COUNT * 100 / $TOTAL )) $(( ($COUNT * 1000 / $TOTAL) % 10 )) $ProgBar
}

# Questiona ao usuário se deve gerar novos dados
echo "Gerar nova base de Órgãos? [S]im ou [N]ão"
rm -i $CSV_ORGAOS 2> /dev/null
if [ -f $CSV_ORGAOS ]
then
   echo "Mantido a relação de Orgãos"
else
    echo "

   Obtendo Órgãos:"
   for idOrgao in `xmlstarlet sel -t -v "//orgaos/orgao/@id" $TMP_ORGAOS` ; do
      let COUNT++

      progresso $(xmlstarlet sel -t -v "//orgaos/orgao/@id" $TMP_ORGAOS | wc -l)

      # Parse no XML da sigla e descrição do Orgão
      siglaOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@sigla" $TMP_ORGAOS)
      descricaoOrgao=$(xmlstarlet sel -t -v "//orgaos/orgao[$COUNT]/@descricao" $TMP_ORGAOS)

      # Plotando no CSV dos Orgãos
      echo $idOrgao\;$siglaOrgao\;$descricaoOrgao >> $CSV_ORGAOS

   done
      echo "Relação de Orgãos atualizado."
fi

echo "Atualizar a Pauta da Semana? [S]im ou [N]ão"
rm -i $CSV_PAUTAS 2> /dev/null
if [ -f $CSV_PAUTAS ]
then
   echo "Mantido a versão atual da Pauta."
else
   COUNT=0
   echo "

   Obtendo Pauta da Semana:"
   for idOrgao in `cat $CSV_ORGAOS | cut -d";" -f1`; do
   # OBTER PAUTAS
   URL_PAUTAS="http://www.camara.gov.br/SitCamaraWS/Orgaos.asmx/ObterPauta?IDOrgao=$idOrgao&datIni=$(date +%d\/%m\/%Y)&datFim=$(date +%d\/%m\/%Y -d "+10 days")"
   wget $URL_PAUTAS -O $TMP_PAUTAS 2> /dev/null
   let COUNT++
   siglaOrgao=$(grep $idOrgao $CSV_ORGAOS | cut -d";" -f2)
   # Progresso da Pauta
   progresso $(cat $CSV_ORGAOS| wc -l)

   # Obter detalhes da Pauta
   PautaCOUNT=0
   for idPauta in `xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao/sigla" $TMP_PAUTAS | sed s/\ /_/g` ; do
      let PautaCOUNT++
      ementaPauta=$(xmlstarlet sel -t -v "//pauta/reuniao/proposicoes/proposicao[$PautaCOUNT]/ementa" $TMP_PAUTAS)
      pontoPauta=$(echo $idPauta | rev | cut -c -2 | rev)
      nomePauta=$(echo $idPauta | sed s/"\/"/":"/g)
      echo $pontoPauta\;$(echo $idPauta | sed s/_/\ /g)\;$siglaOrgao\;$ementaPauta\;$nomePauta \
      | grep -E 'PL_|PEC_' \
      | grep -vE '(Altera|nova redação|revoga|Acrescenta|REQ_)'
   done | head -5 >> $CSV_PAUTAS
   done #idOrgao
   echo "

    Obtenção das pautas, finalizado.

   "
fi

# OBTER DEPUTADOS
COUNT=0

echo "Gerar novos dados dos Deputados? [S]im ou [N]ão"
rm -i $CSV_DEPUTADOS 2> /dev/null

if [ -f $CSV_DEPUTADOS ]
then
   echo "Dados dos Deputados mantido."
else
   echo "

   Obtendo Deputados:"
   idDeputados=`xmlstarlet sel -t -v "//deputados/deputado/ideCadastro" $TMP_DEPUTADOS`

   for ideCadastro in $idDeputados ; do
      let COUNT++

      # Progresso dos Deputados
      progresso $(echo $idDeputados | wc -l)

      # Parser XML dos detalhes do Deputado
      nomeParlamentar=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/nomeParlamentar" $TMP_DEPUTADOS)
      partidoDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/partido" $TMP_DEPUTADOS)
      ufDeputado=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/uf" $TMP_DEPUTADOS)
      urlFoto=$(xmlstarlet sel -t -v "//deputados/deputado[$COUNT]/urlFoto" $TMP_DEPUTADOS)
      sexoDep=$(xmlstarlet sel -t -v "/deputados/deputado[$COUNT]/sexo" $TMP_DEPUTADOS)

      # Capturando detalhe do deputado no orgão
      # URL_DETALHE="http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=$ideCadastro&numLegislatura="
      URL_DETALHE="data/$ideCadastro.xml"
      siglaDeputado=$(xmlstarlet sel -t -v "//Deputados/Deputado/comissoes/comissao[last()]/siglaComissao" $URL_DETALHE | uniq)

      # Gerando CSV dos Deputados
      echo $ideCadastro\;$nomeParlamentar\;$partidoDeputado\;$ufDeputado\;$siglaDeputado\;$urlFoto\;$sexoDep >> $CSV_DEPUTADOS

   done #ideCadastro

   echo "

Deputados obtidos com sucesso.

   "
fi

echo "Gerar nova base para os cartões? [S]im ou [N]ão"
rm -i $CSV_CARDDEP 2> /dev/null
if [ -f $CSV_CARDDEP ]
then
   echo "Base de cartões mantido."
else
   # Gera CSV de Orgaos e Deputados na Pauta
   listOrgPauta=`cat $CSV_PAUTAS | cut -d";" -f 3| sort | uniq`

   for cardOrgao in $listOrgPauta; do
      grep $cardOrgao $CSV_ORGAOS
   done > $CSV_CARDORG

   for cardOrgao in $listOrgPauta; do
      grep $cardOrgao $CSV_DEPUTADOS
   done > $CSV_CARDDEP

   echo "Nova base de cartões gerado."
fi

echo "Finalizado. Agora utilize o CSV no InkscapeGenerator para gerar os cartões em PDF."
