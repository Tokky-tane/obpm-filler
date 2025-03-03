class ObpmWebUi
  def initialize(driver)
    @driver = driver
  end

  def self.init_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = "#{File.expand_path(
      '../../.bin/chrome/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing', __dir__
    )}"
    options.detach = true
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.implicit_wait = 3
    # driver.manage.timeouts.page_load = 30
    driver.manage.window.resize_to(1920, 1080)
    driver
  end
end
