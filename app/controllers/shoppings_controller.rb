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
  
  def location
    x = params[:x].to_f
    y = params[:y].to_f
    respond_with(@shoppings = Shopping.near("address.location" => [x, y]).limit(5))
  end
end
