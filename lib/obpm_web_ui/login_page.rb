class LoginPage < ObpmWebUi
  def initialize(driver, company_id)
    super(driver)
    @driver.get "https://obpm.jp/#{company_id}/login.html"
  end

  def login(id, password)
    id_input.send_keys id
    password_input.send_keys password
    login_button.click
  end

  private

  def id_input
    @driver.find_element(:id, 'actCodeLogin')
  end

  def password_input
    @driver.find_element(:id, 'passwordLogin')
  end

  def login_button
    @driver.find_element(:id, 'buttonLogin')
  end
end
