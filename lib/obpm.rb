# frozen_string_literal: true

require 'selenium-webdriver'

ENV['PATH'] = "#{ENV['PATH']}:#{File.expand_path('../.bin/chromedriver', __dir__)}"

class OBPM
  DELAY_DURATION = 0.075
  def initialize
    @driver = init_driver

    visit
    login(ENV['OBPM_ID'], ENV['OBPM_PASSWORD'])
    transition_input_page

    @calendar = Calendar.new(@driver)
  end

  def set(date, project, process, hour)
    @calendar.select(date)
    select_item(project, process)
    input(hour)
  end

  def fill(date, project, process)
    @calendar.select(date)
    select_item(project, process)
    return if diff >= 0

    input(-diff)
  end

  private

  def init_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.binary = "#{File.expand_path(
      '../.bin/chrome/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing', __dir__
    )}"
    options.detach = true
    driver = Selenium::WebDriver.for :chrome, options: options
    driver.manage.timeouts.implicit_wait = 3
    driver.manage.timeouts.page_load = 30
    driver.manage.window.resize_to(1920, 1080)
    driver
  end

  def visit
    @driver.get("https://obpm.jp/#{ENV.fetch('OBPM_COMPANY_ID')}/menu.html")
    sleep 0.5
  end

  def transition_input_page
    @driver.find_element(:xpath, '//*[@id="menuList"]/li[2]/div/div/a/h1').click
    sleep 1
  end

  def login(id, password)
    @driver.find_element(:xpath, '//*[@id="CommonDialog"]/div[2]/a/span/span').click
    @driver.find_element(:id, 'actCodeLogin').send_keys id
    @driver.find_element(:id, 'passwordLogin').send_keys password
    @driver.find_element(:id, 'buttonLogin').click
  end

  def select_item(project, process)
    @driver.find_element(:id, 'PWIinputMethod').click
    sleep DELAY_DURATION
    @driver.find_element(:id, 'PWITabpjselectBoxSelected').click
    sleep DELAY_DURATION

    # FIXME: プロジェクトが多い時はmore_showをクリックする必要があるが上手く動かない
    # more_show = @driver.find_elements(:id, 'PWIpjMoreShow')[0]
    # sleep 0.5
    # if more_show
    #   more_show.click
    #   sleep 0.5
    #   @driver.find_element(:id, 'PWITabpjselectBoxSelected').click
    #   sleep 0.5
    #   @driver.find_element(:id, 'PWITabpjselectBoxSelected').click
    #   sleep 0.5
    # end
    @driver.find_elements(xpath: '//*[@id="PWITabpjselectBox"]/ul/li')
           .find { |e| e.dom_attribute('value') == project }.click
    sleep DELAY_DURATION

    Selenium::WebDriver::Support::Select
      .new(@driver.find_element(:id, 'select-choice-Process'))
      .select_by(:text, process)
    sleep DELAY_DURATION
  end

  def input(hour)
    elem = @driver.find_element(:id, 'PWITodayInput')
    elem.click
    elem.send_keys :delete while elem.attribute('value').length.positive?
    elem.send_keys hour
  end

  def diff
    @driver.find_element(:id, 'PWIsumTodayDiff').attribute('value').to_f
  end
end

class Calendar
  DELAY = 0.075
  def initialize(driver)
    @driver = driver
    update_current_year_month
  end

  def select(date)
    set_year_month(date.year, date.month)
    set_date(date.day)
  end

  private

  def update_current_year_month
    @year, @month = @driver
                    .find_element(:xpath, '//*[@id="calManHour"]/div[2]/span/div[1]/div[3]/h4')
                    .text.match('(\d+)年(\d+)月')
                    .values_at(1, 2).map(&:to_i)
  end

  def set_year_month(year, month)
    return if @year == year && @month == month

    move(to: :backward) while @year > year
    move(to: :forward) while @year < year
    move(to: :backward) while @month > month
    move(to: :forward) while @month < month
    sleep DELAY
  end

  def set_date(date)
    return if @date == date

    [
      @driver.find_elements(:css, '.ui-datebox-griddate.ui-btn-up-b'),
      @driver.find_elements(:css, '.ui-datebox-griddate.ui-btn-up-c')
    ].flatten.find { |e| e.text == date.to_s }.click
    @date = date
    sleep DELAY
  end

  def move(to:)
    xpath = case to
            when :backward
              '//*[@id="calManHour"]/div[2]/span/div[1]/div[1]/span/span[2]'
            when :forward
              '//*[@id="calManHour"]/div[2]/span/div[1]/div[2]/span/span[2]'
            end
    @driver.find_element(:xpath, xpath).click
    sleep DELAY
    update_current_year_month
    sleep DELAY
  end
end
