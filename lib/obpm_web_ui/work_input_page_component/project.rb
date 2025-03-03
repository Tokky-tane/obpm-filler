module WorkInputPageComponent
  class Project < ObpmWebUi
    def select(project, process)
      input_div.click
      sleep 0.2
      select_project(project)
      sleep 0.2
      select_process(process)
      sleep 0.2
    end

    def input(hour)
      elem = input_input
      elem.click
      elem.send_keys :delete while elem.attribute('value').length.positive?
      elem.send_keys hour
      elem.send_keys :enter
    end

    private

    def select_project(project)
      project_select_a.click
      project_more_show_li&.click
      project_li(project).click
    end

    def select_process(process)
      Selenium::WebDriver::Support::Select.new(process_choice_select).select_by(:text, process)
    end

    def input_div
      @driver.find_element(:id, 'PWIinputMethod')
    end

    def project_select_a
      @driver.find_element(:id, 'PWITabpjselectBoxSelected')
    end

    def project_li(project)
      @driver.find_element(:xpath, "//div[@id=\"PWITabpjselectBox\"]//li[@value=\"#{project}\"]")
    end

    def project_more_show_li
      @driver.manage.timeouts.implicit_wait = 0
      e= @driver.find_element(:id, 'PWIpjMoreShow')
      @driver.manage.timeouts.implicit_wait = 3
      e
    rescue Selenium::WebDriver::Error::NoSuchElementError
      nil
    end

    def process_choice_select
      @driver.find_element(:id, 'select-choice-Process')
    end

    def input_input
      @driver.find_element(:id, 'PWITodayInput')
    end
  end
end
