class Store
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :code,              :type => String
  field :name,              :type => String
  field :description,       :type => String
  field :localization,      :type => String
  field :number,            :type => String
  field :floor,             :type => String
  field :site,              :type => String
  field :url_img_logo,      :type => String
  field :phone_1,           :type => String
  field :phone_2,           :type => String
  field :phone_3,           :type => String
  
  
  belongs_to :shopping
  embeds_many :images
  embeds_one :address, as: :addressed
  has_and_belongs_to_many :categories
  
  def self.saveStore(pStore)
    store = Store.first(conditions: { code: pStore.code, shopping_id: pStore.shopping.id })
    if store.nil? then
      pStore.save!
      return pStore
    else 
      #update 
      store.name = pStore.name
      store.description =  pStore.description
      store.localization = pStore.localization
      store.floor = pStore.floor
      store.number = pStore.number
      store.phone_1 = pStore.phone_1
      store.phone_2 = pStore.phone_2
      store.phone_3 = pStore.phone_3
      store.site = pStore.site
      store.url_img_logo = pStore.url_img_logo
      
      store.images.clear
      store.images = pStore.images
      store.address = pStore.address
      store.shopping = pStore.shopping
      
      if store.categories.nil? or store.categories.empty? then
        store.categories.concat(pStore.categories)
      else
        pStore.categories.each do |categParam|
          indexCateg = store.categories.index(categParam)
          if (indexCateg.nil?) or (indexCateg < 0) then
            store.categories.concat(categParam)
          end
        end
      end
      
      store.save!
    end
    
    return store
  end
  
end