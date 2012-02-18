class HomeController < ApplicationController
  def index
    
    ContactMailer.contact_email("ranieri", "ranieripieper@gmail.com", "subject", "teste msg").deliver
    
  end
end
