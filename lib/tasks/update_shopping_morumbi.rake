# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/shopping_morumbi_parse')

desc "Update Shopping Morumbi"
task :update_shopping_morumbi => :environment do

  puts "**** Inicio update Shopping Morumbi"

  begin
    ShoppingMorumbiParse.new.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
    puts "******** ERROR ********"
  end
  puts "**** Fim update Shopping Morumbi"
end


