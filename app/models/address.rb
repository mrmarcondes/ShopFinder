class Address
  include Mongoid::Document

  field :street, type: String
  field :number, type: String
  field :complement, type: String
  field :neighborhood, type: String
  field :zip_code, type: String
  field :city, type: String
  field :state, type: String
  field :location, type: Array
  
  
  embedded_in :addressed, polymorphic: true
end