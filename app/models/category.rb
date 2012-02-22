class Category
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :id,        :type => Integer
  field :name,        :type => String
  
end