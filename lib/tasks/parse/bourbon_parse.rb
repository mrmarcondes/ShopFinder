# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'
require 'brazilian_string'
require 'iconv'

class BourbonParse

  #Constants
  URL_ROOT = "http://www.bourbonshopping.com.br/site/busca_lista.jsp?shopping=##SHOPPING_NAME##&NRO_PAGINA=1&QTD_REGISTROS=10000&TP_BOURBON=###TP_BOURBON###"
  
  URL_SEARCH_STORES = "&NRO_PAGINA=1&QTD_REGISTROS=10000"
  URL_STORE_DETAIL = "http://www.bourbonshopping.com.br/site/busca_detalhe.jsp?ID_LOJA=###ID_LOJA###&shopping=##SHOPPING_NAME##"
  
  SHOPPING_ASSIS = "assis-brasil"
  SHOPPING_ASSIS_TP_BOURBON = "123"
  
  SHOPPING_COUNTRY = "country"
  SHOPPING_COUNTRY_TP_BOURBON = "126"
  
  SHOPPING_IPIRANGA = "ipiranga"
  SHOPPING_IPIRANGA_TP_BOURBON = "125"
  
  SHOPPING_NOVO_HAMBURGO = "novo-hamburgo"
  SHOPPING_NOVO_HAMBURGO_TP_BOURBON = "149"
  
  SHOPPING_SAO_LEOPOLDO = "sao-leopoldo"
  SHOPPING_SAO_LEOPOLDO_TP_BOURBON = "131"
  
  SHOPPING_SAO_PAULO = "sao-paulo"
  SHOPPING_SAO_PAULO_TP_BOURBON = "127"
  
  @@categoriasNaoCadastradas = "";
  def update

    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_ASSIS, "Bourbon Shopping Assis Brasil", 
                                "Av. Assis Brasil", "164", "São João", "Porto Alegre", 
                                "RS", "91010-000", "(51) 3027-2155", "http://www.bourbonshopping.com.br/site/?shopping=assis-brasil");
#    parse_lojas(SHOPPING_ASSIS, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_ASSIS_TP_BOURBON);
    
    
    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_COUNTRY, "Bourbon Shopping Country", 
                                "Av. Túlio de Rose", "80", "Passo da Areia", "Porto Alegre", 
                                "RS", "91340-110", "(51) 3361-7399", "http://www.bourbonshopping.com.br/site/?shopping=country");
#    parse_lojas(SHOPPING_COUNTRY, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_COUNTRY_TP_BOURBON);
    
    
    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_IPIRANGA, "Bourbon Shopping Ipiranga", 
                                "Av. Ipiranga", "5200", "Jardim Botânico", "Porto Alegre", 
                                "RS", "90610-000", "(51) 3336-0508", "http://www.bourbonshopping.com.br/site/?shopping=ipiranga");
    #parse_lojas(SHOPPING_IPIRANGA, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_IPIRANGA_TP_BOURBON);
    
    
    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_NOVO_HAMBURGO, "Bourbon Shopping Novo Hamburgo", 
                                "Av. Nações Unidas", "2001", "Rio Branco", "Novo Hamburgo", 
                                "RS", "93320-021", "(51) 3593-5100", "http://www.bourbonshopping.com.br/site/?shopping=novo-hamburgo");
    #parse_lojas(SHOPPING_NOVO_HAMBURGO, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_NOVO_HAMBURGO_TP_BOURBON);



    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_SAO_LEOPOLDO, "Bourbon Shopping São Leopoldo", 
                                "Av. Primeiro de Março", "821", "Centro", "São Leopoldo", 
                                "RS", "93010-210", "(51) 3591-3099", "http://www.bourbonshopping.com.br/site/?shopping=sao-leopoldo");
    #parse_lojas(SHOPPING_SAO_LEOPOLDO, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_SAO_LEOPOLDO_TP_BOURBON); 
    

    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_BOURBON_SAO_PAULO, "Bourbon Shopping São Paulo", 
                                "Rua Turiassú", "2100", "Barra Funda", "São Paulo", 
                                "SP", "05005-900", "(11) 3874-5050", "http://www.bourbonshopping.com.br/site/?shopping=sao-paulo");
    parse_lojas(SHOPPING_SAO_PAULO, shopping, ShoppingCategoryDescriptionYetting.categories, SHOPPING_SAO_PAULO_TP_BOURBON);    
      
  end
  

  def parse_lojas(shoppingName, shopping, mapCategories, tpBourbon)
   

    url = URL_ROOT.gsub("##SHOPPING_NAME##", shoppingName)
    url = url.gsub("###TP_BOURBON###", tpBourbon)
    
    puts "[ Parse Lojas Bourbon] " + url
     
    f = open(url)
    f.rewind
    doc = Hpricot(Iconv.conv('iso-8859-1', f.charset, f.readlines.join("\n")))

    (doc/"//div[@id=semBorda]/table/tr").each do |trStore|
      
       (trStore/"//td").each do |tdStore|
         href = tdStore.search("a").first
         onclick = href.attributes['onclick']
          onclick = onclick.gsub("javascript:busca_loja_detalhe(", "")
          posVirgula = onclick.index(");")
          code = onclick[0, posVirgula]
          parse_loja(shoppingName, shopping, mapCategories, code.strip)
          
          #return
       end
     
      
    end

    ParseUtil::updateNrStores(shopping)

  end

  def parse_loja(shoppingName, shopping, mapCategories, code)

    url = URL_STORE_DETAIL.gsub("##SHOPPING_NAME##", shoppingName)
    url = url.gsub("###ID_LOJA###", code)
    
    f = open(url)
    f.rewind
    doc = Hpricot(Iconv.conv('iso-8859-1', f.charset, f.readlines.join("\n")))

    name = doc.search("//div[@id=esquerdaConteudo]/h2").first.innerText

    puts name
    description = ""
    doc.search("//div[@id=descricaoLoja]/*").each do |desc|
      if not desc.innerText.empty? then
        description += desc.innerText.strip + MainYetting.STRING_NEXT_LINE
      end
    end

    #description = doc.search("//div[@id=descricaoLoja]/p/font/font/font").first.innerText
    localization = nil
    email = nil
    site = nil
    categoryArray = Array.new
    phone_1 = nil
    phone_2 = nil
    phone_3 = nil
    url_img = nil
    
    img = doc.search("//div[@id=divFotoLojaDet]/img").first
    if not img.nil? then
      url_img = img.attributes["src"]
      legenda_img = img.attributes["alt"]
    end
    
    doc.search("//div[@id=descricaoAtividade]/ul/li").each do |li|
      
      item = li.innerText.br_downcase
      liInner = li.search("ul")
      
      if item.index("localização") then
       # puts liInner
        localization = liInner.search("//li").first.innerText.strip
      elsif item.index("atividades") then
        atividades = liInner.search("/li").each do |atv|
          categoryArray.push(atv.innerText.strip)
        end
        
        atividades = liInner.search("/li")
        if atividades.size > 1 then
          atividades.each do |atv|
            categoryArray.push(atv.innerText.strip)
          end
        elsif atividades.size == 1 then
           categoryArray.push(atividades.first.innerText.strip)
        end
        
      elsif item.index("telefone") then
        phones = liInner.search("/li")
        if phones.size > 1 then
          phones.each do |phone|
            if phone_1.nil? then
              phone_1 = phone
            elsif phone_2.nil? then
              phone_2 = phone
            elsif phone_3.nil? then
              phone_3 = phone
            end
          end
        elsif phones.size == 1 then
           phone_1 = phones.first.innerText.strip
        end

      elsif item.index("email") then
        email = liInner.search("//li").first.innerText.strip
      elsif item.index("website") then
        site = liInner.search("//li").first.innerText.strip
      end
    end

    store = Store.new
    store.code = code
    store.name = name
    store.description =  description
    store.localization = localization
    if (not phone_1.nil?) and (not phone_1.empty?)  then
      store.phone_1 = phone_1
    end
    if (not phone_2.nil?) and (not phone_2.empty?) then
      store.phone_2 = phone_2
    end
    if (not phone_3.nil?) and (not phone_3.empty?) then
      store.phone_3 = phone_3
    end
    store.site = site
    
    if not (url_img.nil? and url_img.empty?) then
      image = Image.new
      image.url = url_img
      image.description = legenda_img
      
      store.images.concat([ image ])
    end

    store.address = shopping.address
    store.shopping = shopping

    #seta as categorias
    @@categoriasNaoCadastradas += ParseUtil::setCategories(store, categoryArray, mapCategories, shopping)

    store = Store::saveStore(store)

  end
  
end