# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/shopping_morumbi_parse')
require File.join(File.dirname(__FILE__), '/parse/iguatemi_parse')
require File.join(File.dirname(__FILE__), '/parse/bourbon_parse')
require File.join(File.dirname(__FILE__), '/parse/parse_util')

desc "Executa todas as tasks"
task :execute_all => :environment do

  puts "**** Inicio Shopping Morumbi"

  begin
    ShoppingMorumbiParse.new.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
    puts "******** ERROR ********"
    puts e
  end
  puts "**** Fim Shopping Morumbi"
  
  puts "**** Inicio Iguatemi"

  begin
    iguatemiParse = IguatemiParse.new
    iguatemiParse.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
    puts "******** ERROR ********"
    puts e
  end
  puts "**** Fim Iguatemi"
  
  puts "**** Inicio Bourbon"

  begin
    bourbonParse = BourbonParse.new
    bourbonParse.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
   puts "******** ERROR ********"
    puts e
  end
  puts "**** Fim update Bourbon"
  
end


