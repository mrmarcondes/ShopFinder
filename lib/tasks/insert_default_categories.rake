# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'


desc "Insert default Categories"
task :insert_categories => :environment do

  puts "**** Inicio"

  MainYetting.default_categories.each { |key, value| 
    insert(key, value)
  }

  puts "**** Fim"
end

def insert(id, name)
  category = Category.first(conditions: { _id: id })
  if category.nil? then
    category = Category.new
  end
  
  category.id = id
  category.name = name
  
  category.save
end
