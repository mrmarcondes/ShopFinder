class StoresController < ApplicationController
  respond_to :json
    
  def all_by_shopping
    @stores = Store.where(shopping_id: params[:shopping_id].to_i)

    if @stores.count > 0
      respond_with(@stores)
    else
      head 404
    end
  end

end
