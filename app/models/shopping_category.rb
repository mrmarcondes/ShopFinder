class ShoppingCategory
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :code,        :type => String
  field :name,        :type => String
  field :description, :type => String  
  
  belongs_to :shopping
  belongs_to :category

  def self.saveShoppingCategory (code, name, description, shopping)
    shoppingCategory = ShoppingCategory.first(conditions: { code: code, shopping_id: shopping.id })

    if shoppingCategory.nil? then
       shoppingCategory = ShoppingCategory.new
       shoppingCategory.code = code
       category = Category.first(conditions: { code: Yetting.CODE_CATEG_OUTROS })
       shoppingCategory.category = category
    end
    
    shoppingCategory.name = name
    shoppingCategory.description = description
    shoppingCategory.shopping = shopping
    shoppingCategory.save!
  end
  
end