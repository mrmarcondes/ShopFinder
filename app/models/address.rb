require 'geocoder'

class Address
  include Mongoid::Document
  field :street, type: String
  field :number, type: String
  field :complement, type: String
  field :neighborhood, type: String
  field :zip_code, type: String
  field :city, type: String
  field :state, type: String
  field :location, type: Array, :geo => true
  index [[ :location, Mongo::GEO2D ]], :min => -180, :max => 180
  
  embedded_in :addressed, polymorphic: true
end