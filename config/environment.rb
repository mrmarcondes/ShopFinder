# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ShopFinder::Application.initialize!

ShopFinder::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ShopFinder] ",
  :sender_address => %{"notifier" <shop-finder@bol.com.br>},
  :exception_recipients => %w{ranieripieper@gmail.com}
  