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
 
  @@categoriasNaoCadastradas = "";
    
  def update
  
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_MORUMBI, "Shopping Morumbi", 
                                "Av. Roque Petroni Jr.", "1089", "Morumbi", "São Paulo", 
                                "SP", "04707-000", "(11) 4003-4132");
    
    #parse_categorias(shopping)
    parse_lojas(shopping)
  
    #send email com as categorias nao cadastradas
    if not @@categoriasNaoCadastradas.empty? then
      NotificationMailer.notification("Categorias", @@categoriasNaoCadastradas).deliver;
    end
    
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
    ShoppingMorumbiYetting.categories.each { |key,value| 
    #ShoppingCategory.all(conditions: { shopping_id: shopping.id }).each do |category| 
  
      f = open(URL_LISTA_LOJA_CATEGORIA + key)
        
      doc = Hpricot.XML(f)
    
      (doc/"dados/item").each do |item|
        parse_loja(shopping, key, item.at('xml').inner_text, item.at('mapas/mapa/piso').inner_text, item.at('mapas/mapa/luc').inner_text)
      end
    }
    
    ParseUtil::updateNrStores(shopping)
    
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
  
      puts name
      
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
      
      #seta categoria
      @@categoriasNaoCadastradas += ParseUtil::setCategories(store, codeShoppingCategory.split(","), ShoppingMorumbiYetting.categories, shopping)
      
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
    end
  end
  
  def createMsgNotification(shopping, codeShoppingCategory, store)
   return "Shopping <b>" + shopping.name + "</b> Categoria <b>" + codeShoppingCategory  + "</b><br/>Loja: <b><%=@store.code %> - <%=@store.name %> </b>"
  end
end