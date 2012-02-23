# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/iguatemi_parse')
require File.join(File.dirname(__FILE__), '/parse/parse_util')

desc "Update Iguatemi"
task :update_iguatemi => :environment do

  puts "**** Inicio update Iguatemi"

  begin
    iguatemiParse = IguatemiParse.new
    iguatemiParse.update()
  rescue  => e
    ExceptionNotifier::Notifier.background_exception_notification(e)
    puts "******** ERROR ********"
    puts e
  end
  puts "**** Fim update Iguatemi"
end





