class Category
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :code,        :type => Integer
  field :name,        :type => String
  field :description, :type => String  
  
end