class ShoppingsController < ApplicationController
  respond_to :json
  
  def all
    respond_with(@shoppings = Shopping.all)
  end
  
  def id
    begin
      respond_with(@shopping = Shopping.find(params[:id].to_i))
    rescue 
      head 404
    end
  end
end
