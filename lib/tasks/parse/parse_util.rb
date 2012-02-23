# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'
require 'brazilian_string'
require 'iconv'

class ParseUtil
  
  def self.setCategories(store, categoryShopping, mapCategories, shopping) 
    @categoriasNaoCadastradas = ""
    #busca categoria
    categOther = false
    categoryShopping.each do |categ|
      categStr = categ.strip.br_upcase

      idCategory = mapCategories[categStr]
      if idCategory.nil? then
            categOther = true
            puts "***** Categoria não existe " + categStr
            @categoriasNaoCadastradas +=  shopping.name + " - " + categ + "<br/>"
      else
        category = Category.first(conditions: { _id: idCategory })
        store.categories.concat(category)
      end
    end
    
    if store.categories.nil? then
      puts "tamanho: " + store.categories.size
    end

    if categOther and (store.categories.nil? or store.categories.size == 0) then
      idCategory = MainYetting.CODE_CATEG_OUTROS
      categoryOther = Category.first(conditions: { _id: idCategory })
      store.categories.concat(categoryOther)
    end
    
    return @categoriasNaoCadastradas
  end
  
  def self.createShopping(code, name, street, number, neighborhood, city, state, zip_code, phone, site)
    shopping = Shopping.first(conditions: { _id: code })
  
    if shopping.nil? then
      #cria o shopping
      shopping = Shopping.new 
      
    end

    shopping.id = code
    shopping.name = name
    shopping.address = Address.new
    shopping.address.street = street
    shopping.address.number = number
    shopping.address.neighborhood = neighborhood
    shopping.address.city = city
    shopping.address.state = state
    shopping.address.zip_code = zip_code
    shopping.phone = phone
    shopping.site = site
    shopping.save
    
    return shopping
  end
  
  def self.updateNrStores(shopping) 
    shopping.nr_stores = Store.count(conditions: { shopping_id: shopping.id })
    
    shopping.save
  end
end