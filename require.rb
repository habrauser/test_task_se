
module RequireDependencies

  require 'faker'
  require 'watir'
  require 'webdrivers'


  # Chrome Driver
  Selenium::WebDriver::Chrome.driver_path='./chromedriver'

  # Firefox Driver
  Selenium::WebDriver::Firefox.driver_path='./geckodriver'


end