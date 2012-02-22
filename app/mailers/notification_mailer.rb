# encoding: UTF-8

class NotificationMailer < ActionMailer::Base
  default from: "shop-finder@bol.com.br"
  
  def notifiationCategoryDontExist(shopping, codeCateg, store)
    @shopping = shopping
    @codeCateg = codeCateg
    @store = store

    mail(:to => MainYetting.EMAIL_NOTIFICATION, :subject => "[ShopFinder] Categoria não encontrada") do |format|
      format.html { render 'notification_email_category_dont_exist' } #app/view/notification_email.html.erb
    end

  end
  
  def notification(subject, message)
    @message = message

    mail(:to => MainYetting.EMAIL_NOTIFICATION, :subject => "[ShopFinder] " + subject) do |format|
      format.html { render 'notification_email' } #app/view/notification_email.html.erb
    end

  end
  
end
