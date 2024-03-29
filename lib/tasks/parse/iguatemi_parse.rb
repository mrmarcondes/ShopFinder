# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'
require 'brazilian_string'
require 'iconv'

class IguatemiParse

  #Constants
  URL_ROOT_MARKETPLACE = "http://www.marketplace.com.br/"
  URL_ROOT_IGUATEMI_SP = "http://www.iguatemisaopaulo.com.br/"
  URL_ROOT_IGUATEMI_ALPHAVILLE = "http://www.iguatemialphaville.com.br/"
  URL_ROOT_IGUATEMI_CAMPINAS = "http://www.iguatemicampinas.com.br/"
  URL_ROOT_IGUATEMI_FLORIANOPOLIS = "http://www.iguatemiflorianopolis.com.br/"
  URL_ROOT_IGUATEMI_BRASILIA = "http://www.iguatemibrasilia.com.br/"
  
  URL_SEARCH_STORES = "lojas/?categoria="
  URL_LIST_XML_STORES = "/xml/lojas/"
  
  #MODELO 2
  URL_ROOT_IGUATEMI_SAO_CARLOS = "http://www.iguatemisaocarlos.com.br/"
  URL_ROOT_IGUATEMI_BOULEVARD_RIO = "http://www.boulevardrioiguatemi.com.br/"
  URL_ROOT_IGUATEMI_PRAIA_BELAS = "http://www.praiadebelas.com.br/"
  URL_ROOT_IGUATEMI_GALLERIA =  "http://www.galleriashopping.com.br/"
  
  URL_SEARCH_STORES_MOD_2 = "page/ajx_lojasporsegmento.asp"
  URL_DETAIL_STORE_MOD_2 = "page/lojas.asp?cod="
  
  @@categoriasNaoCadastradas = "";
  def update
    puts "*** Início Iguatemi"
    updateIguatemi()
    puts "*** Fim Iguatemi"
  end
  
  def updateIguatemi
    #print_categoriasIguatemi(URL_ROOT_IGUATEMI_SP)

    #MODELO2
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_SAO_CARLOS, "Shopping Iguatemi São Carlos", 
                                "Passeio dos Flamboyants", "200", "Parque Faber", "São Carlos", 
                                "SP", "13561-352", "(16) 3372-4233", "http://www.iguatemisaocarlos.com.br/");
    parse_lojas_modelo_2(URL_ROOT_IGUATEMI_SAO_CARLOS, shopping, ShoppingCategoryDescriptionYetting.categories);
    

    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_BOULEVARD_RIO, "Shopping Boulevard Rio Iguatemi", 
                                "Rua Barão de São Francisco", "", "Vila Isabel", "Rio de Janeiro", 
                                "RJ", "13561-352", "(21) 2577-8777", "http://www.boulevardrioiguatemi.com.br/");
    parse_lojas_modelo_2(URL_ROOT_IGUATEMI_BOULEVARD_RIO, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_PRAIA_BELAS, "Shopping Praia de Belas", 
                                "Av. Praia de Belas", "1181", "Menino Deus", "Porto Alegre", 
                                "RS", "90110-000", "(51) 3131-1700", "http://www.praiadebelas.com.br/");
    parse_lojas_modelo_2(URL_ROOT_IGUATEMI_PRAIA_BELAS, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_GALLERIA, "Galleria Shopping", 
                                "Rodovia Dom Pedro I, km 1315", "", "Jardim Nilópolis", "Campinas", 
                                "SP", "13561-352", "(19) 3207-1333", "http://www.galleriashopping.com.br/");
    parse_lojas_modelo_2(URL_ROOT_IGUATEMI_GALLERIA, shopping, ShoppingCategoryDescriptionYetting.categories);

    ##MODELO 1
  
    #marketplace
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_MARKETPLACE_SP, "Shopping Market Place", 
                                "Av. Dr. Chucri Zaidan", "902", "Santo Amaro", "São Paulo", 
                                "SP", "04583-110", "(11)3048-7000", "http://www.marketplace.com.br/");
    parse_lojas(URL_ROOT_MARKETPLACE, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    #Iguatemi
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_SP, "Iguatemi São Paulo", 
                                "Av. Brigadeiro Faria Lima", "2232 ", "Jardim Paulistano", "São Paulo", 
                                "SP", "01451-000", "(11) 3816-6116", "http://www.iguatemisaopaulo.com.br/");
    parse_lojas(URL_ROOT_IGUATEMI_SP, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    #Iguatemi Alphaville
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_ALPHAVILLE, "Iguatemi Alphaville", 
                                "Alameda Rio Negro", "111 ", "Alphaville Industrial", "Barueri", 
                                "SP", "06454-000", "(11) 2078-8000", "http://www.iguatemialphaville.com.br/");
    parse_lojas(URL_ROOT_IGUATEMI_ALPHAVILLE, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    #Iguatemi Campinas
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_CAMPINAS, "Iguatemi Campinas", 
                                "Av. Iguatemi", "777 ", "Vila Brandina", "Campinas", 
                                "SP", "13092-500", "(19) 4005-9510", "http://www.iguatemicampinas.com.br/");
    parse_lojas(URL_ROOT_IGUATEMI_CAMPINAS, shopping, ShoppingCategoryDescriptionYetting.categories);

    #Iguatemi Florianópolis
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_FLORIANOPOLIS, "Iguatemi Florianópolis", 
                                "Av. Madre Benvenuta", "687 ", "Santa Mônica", "Florianópolis", 
                                "SC", "", "(48) 3239-8700", "http://www.iguatemiflorianopolis.com.br/");
    parse_lojas(URL_ROOT_IGUATEMI_FLORIANOPOLIS, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    
     #Iguatemi Florianópolis
    shopping = ParseUtil::createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_BRASILIA, "Iguatemi Brasília", 
                                "SHIN CA 4", "LOTE A ", "LAGO NORTE", "Brasília", 
                                "DF", "", "(61) 3577-5000", "http://www.iguatemibrasilia.com.br/");
    parse_lojas(URL_ROOT_IGUATEMI_BRASILIA, shopping, ShoppingCategoryDescriptionYetting.categories);
    
    
    #send email com as categorias nao cadastradas
    if not @@categoriasNaoCadastradas.empty? then
      NotificationMailer.notification("Categorias", @@categoriasNaoCadastradas).deliver;
    end
  end
  
  def parse_lojas_modelo_2(rootUrl, shopping, mapCategories)
    puts "[ Parse Lojas  Modelo 2] " + rootUrl + URL_SEARCH_STORES_MOD_2

    f = open(rootUrl + URL_SEARCH_STORES_MOD_2)
    f.rewind
    doc = Hpricot(Iconv.conv('utf-8', f.charset, f.readlines.join("\n")))

    (doc/"//div").each do |div|
      
      onclick = div.attributes['onclick']
      onclick = onclick.gsub("definirLoja(", "")
      posVirgula = onclick.index(",")
      code = onclick[0, posVirgula]
      parse_loja_modelo_2(rootUrl, shopping, mapCategories, code)
      
    end

    ParseUtil::updateNrStores(shopping)

  end

  def parse_loja_modelo_2(rootUrl, shopping, mapCategories, code)

    f = open(rootUrl + URL_DETAIL_STORE_MOD_2 + code)
    f.rewind
    doc = Hpricot(Iconv.conv('utf-8', f.charset, f.readlines.join("\n")))

    table = doc.search("//table[@class=texto_branco]").search("//table[@width=92%]")
    logo = nil
    img = table.search("img").first
    if not img.nil? then
      logo = img.attributes['src'].gsub("../", "")
    end
    
    info = table.search("//td[@class=tit_filme]")
    
    nameCateg = info.at('strong').innerText
    descPhone = info.search("//span[@class=texto_marron]").first.innerText
    
    name = nil
    categoryArray = Array.new
    nameCateg.each_line do |str|
      if "" == str.strip then
        next
      end
      if name.nil? then
        name = str.strip
      else
        categoryArray.push(str.strip)
      end
    end

    description = nil
    phone = nil
    site = nil
    descPhone.each_line do |str|
      if "" == str.strip then
        next
      end
      if not str.downcase.index("descrição").nil? then
        description = str.gsub("Descrição:", "").strip
        next
      end

      if not str.downcase.index("telefone").nil? then
        phone = str.gsub("Telefone:", "").strip
        next
      end

      if not str.downcase.index("site").nil? then
        site = str.gsub("Site:", "").strip
        next
      end 
    end
    
    puts name

    store = Store.new
    store.code = code
    store.name = name
    store.description =  description
    #store.localization = localization
    #store.floor = floor
    #store.number = number
    store.phone_1 = phone
    store.site = site
    if !logo.nil? and !logo.empty? then
        store.url_img_logo = rootUrl + logo
    end
    
    store.address = shopping.address
    store.shopping = shopping

    #seta as categorias
    @@categoriasNaoCadastradas += ParseUtil::setCategories(store, categoryArray, mapCategories, shopping)

    store = Store::saveStore(store)

  end
  
 def parse_lojas(rootUrl, shopping, mapCategories)
    puts "[ Parse Lojas] " + rootUrl

    doc = open(rootUrl + URL_LIST_XML_STORES) { |f| Hpricot(f) }
  
    (doc/"//ul/li").each do |xmlLoja|
      
      xml = xmlLoja.at("a").innerText
      
      if xml.index(".xml").nil? or  xml.index(".xml") < 0 or xml.strip == "lojas.xml" or 
          (xml.strip == "44.xml" and rootUrl == URL_ROOT_IGUATEMI_ALPHAVILLE) then
        next
      end
      
      parse_loja(rootUrl, shopping, xml.strip.gsub(/[ ]/, ' ' => '%20'), mapCategories)

    end
    
    ParseUtil::updateNrStores(shopping)
    
  end
  
  def parse_loja(rootUrl, shopping, xml, mapCategories)

    f = open(rootUrl + URL_LIST_XML_STORES + xml)
    doc = Hpricot.XML(f)

    fields = (doc/"add/doc")
    code = fields.at("field[@name=id]").innerText
    name = fields.at("field[@name=name]").innerText
    description = fields.at("field[@name=content]").innerText
    #localization = fields.at("field[@name=id]").innerText
    #phone = fields.at("field[@name=id]").innerText
    site = fields.at("field[@name=site]").innerText
    logo = fields.at("field[@name=logo]").innerText
    floor = fields.at("field[@name=piso]").innerText
    number = fields.at("field[@name=numero_loja]").innerText
    
    urlGetPhone = fields.at("field[@name=permalink]").innerText
    
    subCategoria = nil
    subCategoriaXml = fields.at("field[@name=sub-category]")
    if not subCategoriaXml.nil? then
      subCategoria = subCategoriaXml.innerText
    end
    categorias = fields.at("field[@name=categorias]").innerText
    if categorias.empty? then
      if subCategoria.nil? or subCategoria.empty? then
        categorias = "OUTROS";
      elsif subCategoria.downcase == "restaurante".downcase then
          categorias = "ALIMENTAÇÃO";
      end
    end
    
    puts name
       
    store = Store.new
    store.code = code
    store.name = name
    store.description =  description
    #store.localization = localization
    store.floor = floor
    store.number = number
    store.phone_1 = getPhone(rootUrl, urlGetPhone)
    store.site = site
    if !logo.nil? and !logo.empty? then
        store.url_img_logo = rootUrl + logo
    end
    
    store.address = shopping.address
    store.shopping = shopping

    #seta as categorias
    @@categoriasNaoCadastradas += ParseUtil::setCategories(store, categorias.split(","), mapCategories, shopping)   

    store = Store::saveStore(store)
    
  end

  def getPhone(rootUrl, urlGetPhone)
    doc = open(rootUrl + urlGetPhone.gsub(/[ ]/, ' ' => '%20') ) { |f| Hpricot(f) }
    (doc/"//div[@id=infoStore]").each do |item|

      phoneSite = (item/"div")
      phoneSpan =  (item/"div/span")
      if phoneSite.at("span").nil? then
        return nil
      end
      phone = phoneSite.at("span").innerText
      return phone
    end
  end
  
  def parse_lojas2(rootUrl, shopping, mapCategories)
    puts "[ Parse Lojas ] " + rootUrl
  
    
  
    mapCategories.each { |key,value| 

      doc = open(rootUrl + URL_SEARCH_STORES + key) { |f| Hpricot(f) }
    
      (doc/"//div[@id=searchResults]/ul/li").each do |item|
        
        logo = item.at("img").attributes['src']
        divLocalizacao = item.at("div[@class=sprite bullet02]")
        resumeLocal = (divLocalizacao/"var")
        piso = resumeLocal[0].innerText
        numero = resumeLocal[1].innerText
        
        urlStore = item.at("a[@class=sprite btMore]").attributes['href']
        
        parse_loja(rootUrl, shopping, value, urlStore, logo, piso, numero)
      end
      
    }

    
    puts "[Fim parse Categorias]" 
    
  end
  
  def parse_loja2(rootUrl, shopping, categShopFinder, urlStore, logo, piso, numero)
    doc = open(rootUrl + urlStore ) { |f| Hpricot(f) }
    puts "Parse Loja"
    (doc/"//div[@id=infoStore]").each do |item|
      
      name = item.at("h1").innerText
      phoneSite = (item/"div")
      phoneSpan =  (item/"div/span")
      phone = phoneSite.at("span").innerText
     # site = phoneSite.at("address/a").innerHTML#.at("a").attributes['href']
      
      #parse_loja(rootUrl, shopping, value, urlStore, logo, piso, numero)
    end
  end
  
  def parse_categoriasIguatemi(rootUrl)
    puts "[ Parse categorias ] " + rootUrl
  
    doc = open(rootUrl) { |f| Hpricot(f) }
  
    #puts doc 
    (doc/"//select[@id=storeCategoryDrop]/option").each do |item|
      
      name = item.innerHTML
  
      puts name
      
    end
    
    puts "[Fim parse Categorias]" 
    
  end
end
