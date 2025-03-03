class MenuPage < ObpmWebUi
  def enter_work_input_page
    work_input_button.click
  end

  private

  def work_input_button
    @driver.find_element(:xpath, '//ul[@id="menuList"]//h1[contains(text(), "工数入力")]')
  end
end
