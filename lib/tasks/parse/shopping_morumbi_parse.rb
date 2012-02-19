# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

class ShoppingMorumbiParse
  
  #Constants
  URL_LISTA_CATEGORIA = "http://www.morumbishopping.com.br/novo_site/content/xml/lojas/comboLoja.xml"
  URL_LISTA_LOJA_CATEGORIA = "http://www.morumbishopping.com.br/novo_site/phps/busca.new.php?atividade1="
  URL_DETALHE_LOJA = "http://www.morumbishopping.com.br/novo_site/content/xml/lojas/"
  URL_PATH_IMAGEM_LOGO = "http://www.morumbishopping.com.br/novo_site/content/images/lojas/"
  URL_PATH_IMAGEM = "http://www.morumbishopping.com.br/novo_site/content/images/"
  
  def update
  
    #verifica se o shopping está na base
    shopping = Shopping.first(conditions: { code: MainYetting.CODE_SHOPPING_MORUMBI })
  
    if shopping.nil? then
      #cria o shopping
      shopping = Shopping.new 
      
    end
    
    shopping.code = MainYetting.CODE_SHOPPING_MORUMBI
    shopping.name = "Shopping Morumbi"
    shopping.address = Address.new
    shopping.address.street = "Av. Roque Petroni Jr."
    shopping.address.number = "1089"
    shopping.address.neighborhood = "Morumbi"
    shopping.address.city = "São Paulo"
    shopping.address.state = "SP"
    shopping.address.zip_code = "04707-000"
    shopping.phone = "(11) 4003-4132"
    
    puts "*** Salvando shopping"
  
    shopping.save
    #parse_categorias(shopping)
    parse_lojas(shopping)
  
  end
  
  def parse_categorias(shopping)
    puts "[ Parse categorias ]"
    f = open(URL_LISTA_CATEGORIA)
  
    doc = Hpricot.XML(f)
      
    (doc/"dados/item").each do |item|
      
      code = item.at('codigo').inner_text
      name = item.at('texto').innerHTML
  
      ShoppingCategory::saveShoppingCategory(code, name, nil, shopping)
      
    end
    
    puts "[Fim parse Categorias]" 
    
  end
  
  def parse_lojas(shopping)
    puts "[ Parse Lojas ]"
    #busca as categorias do shopping
    ShoppingCategory.all(conditions: { shopping_id: shopping.id }).each do |category| 
  
      f = open(URL_LISTA_LOJA_CATEGORIA + category.code)
        
      doc = Hpricot.XML(f)
    
      (doc/"dados/item").each do |item|
        parse_loja(shopping, category.code, item.at('xml').inner_text, item.at('mapas/mapa/piso').inner_text, item.at('mapas/mapa/luc').inner_text)
      end
    end
    
    puts "[Fim parse Lojas]" 
    
  end
  
  def parse_loja(shopping, codeShoppingCategory, xmlLoja, floor, number)
  
    f = open(URL_DETALHE_LOJA + xmlLoja)
    
    doc = Hpricot.XML(f)
      
    (doc/"dados").each do |item|
      
      name = item.at('nome').inner_text
      code = item.at('codloja').inner_text
      description = item.at('release').inner_text
      localization = item.at('localizacao').inner_text
      phone = item.at('telefone').inner_text
      site = item.at('url').inner_text
      logo = item.at('logo').inner_text
  
      store = Store.new
      store.code = code
      store.name = name
      store.description =  description
      store.localization = localization
      store.floor = floor
      store.number = number
      store.phone_1 = phone
      #store.phone_2 = nil
      #store.phone_3 = nil
      store.site = site
      if !logo.nil? and !logo.empty? then
          store.url_img_logo = URL_PATH_IMAGEM_LOGO + logo
      end
      
      store.address = shopping.address
      store.shopping = shopping
      
      #busca categoria
      codeShoppingCat = ShoppingMorumbiYetting.categories[codeShoppingCategory]
      if codeShoppingCat.nil? then
          codeShoppingCat = MainYetting.CODE_CATEG_OUTROS
          puts "***** Categoria não existe " + codeShoppingCategory
      end
      category = Category.first(conditions: { code: codeShoppingCat })
      store.categories.concat(category)
      
      #imagens
      (item/"imagem/imagem_item").each do |img|
        url = img.at('imagem').inner_text
        legenda = img.at('legenda').inner_text
        
        if url == logo then
          continue
        end
          
        if !url.nil? and !url.empty? then
          url = URL_PATH_IMAGEM + url
        end
        image = Image.new
        image.url = url
        image.description = legenda
        
        store.images.concat([ image ])
      end
      
      store = Store::saveStore(store)
  
      shopping.nrSotres = Store.count(conditions: { shopping_id: shopping.id })
      
      shopping.save
    end
  end
  
  def createMsgNotification(shopping, codeShoppingCategory, store)
   return "Shopping <b>" + shopping.name + "</b> Categoria <b>" + codeShoppingCategory  + "</b><br/>Loja: <b><%=@store.code %> - <%=@store.name %> </b>"
  end
end