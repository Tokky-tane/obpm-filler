require 'selenium-webdriver'
require_relative 'obpm_web_ui/obpm_web_ui'
require_relative 'obpm_web_ui/login_page'
require_relative 'obpm_web_ui/menu_page'
require_relative 'obpm_web_ui/work_input_page'

ENV['PATH'] = "#{ENV['PATH']}:#{File.expand_path('../.bin/chromedriver', __dir__)}"

class ObpmWeb
  def initialize(id:, password:, company_id:)
    driver = ObpmWebUi.init_driver
    LoginPage.new(driver, company_id).login(id, password)
    MenuPage.new(driver).enter_work_input_page
    @work_input_page = WorkInputPage.new(driver)
  end

  def input(date, project, process, hour = nil)
    unless hour.nil?
      @work_input_page.input(date, project, process, hour)
      return
    end

    hour = (@work_input_page.today_diff) * -1
    @work_input_page.input(date, project, process, hour)
  end
end
