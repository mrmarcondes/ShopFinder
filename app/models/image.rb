class Image

  include Mongoid::Document
  
  field :url,        :type => String
  field :description, :type => String  
  
   embedded_in :store
end