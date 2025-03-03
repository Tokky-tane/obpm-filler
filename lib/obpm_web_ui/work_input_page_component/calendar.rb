module WorkInputPageComponent
  class Calendar < ObpmWebUi
    def set(date)
      select_year_month(date)
      date_box(date).click
    end

    private

    def current_date
      year, month, date = current_date_header
                          .text
                          .match(/(\d{4})\/(\d{2})\/(\d{2})/).captures.map(&:to_i)
      Date.new(year, month, date)
    end

    def select_year_month(date)
      current_date = current_date()

      while current_date.year != date.year || current_date.month != date.month
        if current_date > date
          backward_month_button.click
        else
          forward_month_button.click
        end
        current_date = current_date()
      end
    end

    def date_box(date)
      id = "OBPMcalenderMarkd#{date.year.to_s.rjust(2, '0')}_#{date.month.to_s.rjust(2, '0')}_#{date.day.to_s.rjust(2, '0')}"
      @driver.find_element(:xpath, "//div[@id = \"#{id}\"]")
    end

    def current_date_header
      @driver.find_element(:id, 'PWIListhead')
    end

    def forward_month_button
      @driver.find_element(:xpath, '//div[@id="PWIcalenderContainer"]//div[@title="次月"]')
    end

    def backward_month_button
      @driver.find_element(:xpath, '//div[@id="PWIcalenderContainer"]//div[@title="前月"]')
    end
  end
end
