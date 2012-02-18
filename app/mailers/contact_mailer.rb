class ContactMailer < ActionMailer::Base
  default from: "shop-finder@bol.com.br"
  
  def contact_email(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message
    mail(:to => email, :subject => subject)
    
    mail(:to => email, :subject => subject) do |format|
      format.html { render 'contact_email' } #app/view/contact_email.html.erb
    end

  end
  
end
