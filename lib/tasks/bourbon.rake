# encoding: UTF-8

require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'yettings'
require 'geocoder'

require File.join(File.dirname(__FILE__), '/parse/bourbon_parse')
require File.join(File.dirname(__FILE__), '/parse/parse_util')

desc "Update BOURBON"
task :update_bourbon => :environment do

  puts "**** Inicio update Bourbon"

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





