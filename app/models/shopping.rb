class Shopping
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :code,        :type => String
  field :name,        :type => String
  field :phone,       :type => String
  field :email,       :type => String
  field :nrSotres,    :type => Integer
  
  embeds_one :address, as: :addressed
  has_many :stores

  before_save :set_location

  def set_location
    if not self.address.nil? then
      self.address.location = Geocoder.coordinates(self.address.street  + " " + self.address.number + "," + 
                                                      self.address.city + " " + self.address.state)      
    end
  end

end