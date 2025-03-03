module WorkInputPageComponent
  class Summary < ObpmWebUi
    def today_diff
      today_diff_input.attribute('value').to_f
    end

    private

    def today_diff_input
      @driver.find_element(:id, 'PWIsumTodayDiff')
    end
  end
end
