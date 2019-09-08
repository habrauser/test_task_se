class Browser

  def initialize(browser, headless)
    @browser = Watir::Browser.new browser, headless: headless
  end

  def open(link)
    @browser.goto link
    @browser.link(id: 'demo-link').click
    sleep(1)
    @browser.link(href: '/EBank/accounts').click
    sleep(1)
  end

end