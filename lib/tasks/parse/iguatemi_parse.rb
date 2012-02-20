# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'
require 'brazilian_string'

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
  
  @@categoriasNaoCadastradas = "";
  def update
    puts "*** Início Iguatemi"
    updateIguatemi()
    puts "*** Fim Iguatemi"
  end
  
  def updateIguatemi
    #print_categoriasIguatemi(URL_ROOT_IGUATEMI_SP)

    #marketplace
    shopping = createShopping(MainYetting.CODE_SHOPPING_MARKETPLACE_SP, "Shopping Market Place", 
                                "Av. Dr. Chucri Zaidan", "902", "Santo Amaro", "São Paulo", 
                                "SP", "04583-110", "(11)3048-7000");
    parse_lojas(URL_ROOT_MARKETPLACE, shopping, IguatemiYetting.categories);
    
    #Iguatemi
    shopping = createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_SP, "Iguatemi São Paulo", 
                                "Av. Brigadeiro Faria Lima", "2232 ", "Jardim Paulistano", "São Paulo", 
                                "SP", "01451-000", "(11) 3816-6116");
    parse_lojas(URL_ROOT_IGUATEMI_SP, shopping, IguatemiYetting.categories);
    
    #Iguatemi Alphaville
    shopping = createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_ALPHAVILLE, "Iguatemi Alphaville", 
                                "Alameda Rio Negro", "111 ", "Alphaville Industrial", "Barueri", 
                                "SP", "06454-000", "(11) 2078-8000");
    parse_lojas(URL_ROOT_IGUATEMI_ALPHAVILLE, shopping, IguatemiYetting.categories);
    
    #Iguatemi Campinas
    shopping = createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_CAMPINAS, "Iguatemi Campinas", 
                                "Av. Iguatemi", "777 ", "Vila Brandina", "Campinas", 
                                "SP", "13092-500", "(19) 4005-9510");
    parse_lojas(URL_ROOT_IGUATEMI_CAMPINAS, shopping, IguatemiYetting.categories);

    #Iguatemi Florianópolis
    shopping = createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_FLORIANOPOLIS, "Iguatemi Florianópolis", 
                                "Av. Madre Benvenuta", "687 ", "Santa Mônica", "Florianópolis", 
                                "SC", "", "(48) 3239-8700");
    parse_lojas(URL_ROOT_IGUATEMI_FLORIANOPOLIS, shopping, IguatemiYetting.categories);
    
    
     #Iguatemi Florianópolis
    shopping = createShopping(MainYetting.CODE_SHOPPING_IGUATEMI_BRASILIA, "Iguatemi Brasília", 
                                "SHIN CA 4", "LOTE A ", "LAGO NORTE", "Brasília", 
                                "DF", "", "(61) 3577-5000");
    parse_lojas(URL_ROOT_IGUATEMI_BRASILIA, shopping, IguatemiYetting.categories);
    
    
    #send email com as categorias nao cadastradas
    if not @@categoriasNaoCadastradas.empty? then
      NotificationMailer.notification("Categorias", @@categoriasNaoCadastradas).deliver;
    end
  end
  
  def parse_lojas(rootUrl, shopping, mapCategories)
    puts "[ Parse Lojas ] " + rootUrl

    doc = open(rootUrl + URL_LIST_XML_STORES) { |f| Hpricot(f) }
  
    (doc/"//ul/li").each do |xmlLoja|
      
      xml = xmlLoja.at("a").innerText
      
      if xml.index(".xml").nil? or  xml.index(".xml") < 0 or xml.strip == "lojas.xml" or 
          (xml.strip == "44.xml" and rootUrl == URL_ROOT_IGUATEMI_ALPHAVILLE) then
        next
      end
      
      parse_loja(rootUrl, shopping, xml.strip.gsub(/[ ]/, ' ' => '%20'), mapCategories)

    end
      
  end
  
  
  def parse_loja(rootUrl, shopping, xml, mapCategories)
    puts "Parse Loja"

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

    #busca categoria
    
    categoryArray = categorias.split(",")
    
    categOther = false
    categoryArray.each do |categ|
      categStr = categ.strip.br_upcase

      codeShoppingCat = mapCategories[categStr]
      if codeShoppingCat.nil? then
            categOther = true
            puts "***** Categoria não existe " + categStr
            @@categoriasNaoCadastradas +=  shopping.name + " - " + categ + "<br/>"
      else
        category = Category.first(conditions: { code: codeShoppingCat })
        store.categories.concat(category)
      end
    end
    
    if store.categories.nil? then
      puts "tamanho: " + store.categories.size
    end


    if categOther and (store.categories.nil? or store.categories.size == 0) then
      codeShoppingCat = MainYetting.CODE_CATEG_OUTROS
      categoryOther = Category.first(conditions: { code: codeShoppingCat })
      store.categories.concat(categoryOther)
    end

    store = Store::saveStore(store)

    shopping.nrSotres = Store.count(conditions: { shopping_id: shopping.id })
    
    shopping.save
         
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
  
  def createShopping(code, name, street, number, neighborhood, city, state, zip_code, phone)
    shopping = Shopping.first(conditions: { code: code })
  
    if shopping.nil? then
      #cria o shopping
      shopping = Shopping.new 
      
    end
    
    shopping.code = code
    shopping.name = name
    shopping.address = Address.new
    shopping.address.street = street
    shopping.address.number = number
    shopping.address.neighborhood = neighborhood
    shopping.address.city = city
    shopping.address.state = state
    shopping.address.zip_code = zip_code
    shopping.phone = phone
    
    shopping.save
    
    return shopping
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
