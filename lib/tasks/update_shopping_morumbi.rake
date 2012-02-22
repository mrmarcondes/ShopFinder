# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/shopping_morumbi_parse')
require File.join(File.dirname(__FILE__), '/parse/parse_util')

desc "Update Shopping Morumbi"
task :update_shopping_morumbi => :environment do

  puts "**** Inicio update Shopping Morumbi"

  begin
    ShoppingMorumbiParse.new.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
    puts "******** ERROR ********"
    puts e
  end
  puts "**** Fim update Shopping Morumbi"
end


