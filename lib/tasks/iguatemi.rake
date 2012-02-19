# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/iguatemi_parse')

desc "Update Iguatemi"
task :update_iguatemi => :environment do

  puts "**** Inicio update Iguatemi"

  iguatemiParse = IguatemiParse.new
  iguatemiParse.update()
 # begin
 #   updateIguatemi()
 # rescue  => e
 #   ExceptionNotifier::Notifier.background_exception_notification(e)
 #   puts "******** ERROR ********"
 # end
  puts "**** Fim update Iguatemi"
end





