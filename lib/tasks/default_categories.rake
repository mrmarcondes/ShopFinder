# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'


desc "Insert default Categories"
task :insert_categories => :environment do

  puts "**** Inicio"

  insert(1, 'OUTROS', 'OUTROS')
  insert(2, 'ACADEMIA DE GINÁSTICA', 'ACADEMIA DE GINÁSTICA')
  insert(3, 'ACESSÓRIOS', 'ACESSÓRIOS')
  insert(4, 'DECORAÇÃO', 'DECORAÇÃO')
  insert(5, 'TURISMO/VIAGENS', 'TURISMO/VIAGENS')
  insert(6, 'ARMARINHO', 'ARMARINHO')
  insert(7, 'ELETÔNICOS', 'ELETÔNICOS')
  insert(8, 'ARTIGOS ESPORTIVOS', 'ARTIGOS ESPORTIVOS')
  insert(9, 'ARTIGOS INFANTIS', 'ARTIGOS INFANTIS')
  insert(10, 'BANCOS', 'BANCOS')
  insert(11, 'BRINQUEDOS', 'BRINQUEDOS')
  insert(12, 'BELEZA', 'BELEZA')
  insert(13, 'CALÇADOS', 'CALÇADOS')
  insert(14, 'CAMA/MESA/BANHO', 'CAMA/MESA/BANHO')
  insert(15, 'CASAS DE CÂMBIO', 'CASAS DE CÂMBIO')
  insert(16, 'CDS/DVDS', 'CDS/DVDS')
  insert(17, 'CINEMAS', 'CINEMAS')
  insert(18, 'DELICATESSEN', 'DELICATESSEN')
  insert(19, 'LAZER', 'LAZER')
  insert(20, 'ELETRODOMÉSTICOS', 'ELETRODOMÉSTICOS')
  insert(21, 'ESTÉTICA', 'ESTÉTICA')
  insert(22, 'FARMÁCIA/DROGARIA', 'FARMÁCIA/DROGARIA')
  insert(23, 'FLORES', 'FLORES')
  insert(24, 'GAMES', 'GAMES')
  insert(25, 'INFORMÁTICA', 'INFORMÁTICA')
  insert(26, 'JÓIAS/RELÓGIOS/ÓTICA', 'JÓIAS/RELÓGIOS/ÓTICA')
  insert(27, 'FOTO REVELAÇÃO', 'FOTO REVELAÇÃO')
  insert(28, 'LAVA RÁPIDO', 'LAVA RÁPIDO')
  insert(29, 'MODA ÍNTIMA (LINGERIE/MEIAS)', 'MODA ÍNTIMA (LINGERIE/MEIAS)')
  insert(30, 'LIVRARIA', 'LIVRARIA')
  insert(31, 'LOJA DE DEPARTAMENTOS', 'LOJA DE DEPARTAMENTOS')
  insert(32, 'LOUÇAS/CRISTAIS/PRATARIAS', 'LOUÇAS/CRISTAIS/PRATARIAS')
  insert(33, 'MODA PRAIA (BIQUINIS/MAIÔS/SUNGAS)', 'MODA PRAIA (BIQUINIS/MAIÔS/SUNGAS)')
  insert(34, 'ARTIGOS DO LAR', 'ARTIGOS DO LAR')
  insert(35, 'PAPELARIA', 'PAPELARIA')
  insert(36, 'PETSHOP', 'PETSHOP')
  insert(37, 'PRESENTE/SOUVENIR', 'PRESENTE/SOUVENIR')
  insert(38, 'TABACARIA', 'TABACARIA')
  insert(39, 'TELEFONES/ACESSÓRIOS', 'TELEFONES/ACESSÓRIOS')
  insert(40, 'VESTUÁRIO', 'VESTUÁRIO')
  insert(41, 'SERVIÇOS', 'SERVIÇOS')
  insert(42, 'COSMÉTICOS', 'COSMETICOS')
  insert(43, 'MODA JOVEM', 'MODA JOVEM')
  puts "**** Fim"
end

def insert(code, name, description)
  category = Category.first(conditions: { code: code })
  if category.nil? then
    category = Category.new
  end
  
  category.code = code
  category.name = name
  category.description = description
  
  category.save
end
