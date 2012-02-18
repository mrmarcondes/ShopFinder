ActionMailer::Base.smtp_settings = {
  :address              => "smtps.bol.com.br",
  :port                 => 587,
  :domain               => "bol.com.br",
  :user_name            => "shop-finder@bol.com.br",
  :password             => "shoP123",
  :authentication       => "plain",
  :enable_starttls_auto => true
  
}