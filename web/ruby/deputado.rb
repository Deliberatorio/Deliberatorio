#
#   Deliberatório Web - Script para gerar os dados para carta do jogo na web
#   Copyright (C) 2013 Valessio Brito <contato@valessiobrito.com.br>
#                      Daniel Costa Bucher <daniel.bucher88@gmail.com>
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

class Deputado
  
  attr_accessor :nome, :partido, :uf, :url_foto

  def print
    puts "#{nome};#{partido};#{uf};#{url_foto};"
  end
  
end
