class ShoppingsController < ApplicationController
  respond_to :json
  
  def all
    respond_with(@shoppings = Shopping.all)
  end
  
  def id
    respond_with(@shopping = Shopping.where(id: params[:id]))
  end
end
