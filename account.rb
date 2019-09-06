class Account

  def initialize(browser, headless)
    @browser = Watir::Browser.new browser, headless: headless
  end

  def open(goto)

    @browser.goto goto
    @browser.link(id: 'demo-link').click
    @browser.link(href: '/EBank/accounts').click

  end

  def collect

    sleep(0.2)

    @ibans = []
    divs = @browser.divs(class: %w[display-inl-block bg-circle-acc])
    divs.each do |div|
      @ibans << div.link.text
    end

    @accounts = []

    account_data_collect(@ibans)

    @hash = {accounts: @accounts}

    puts @hash.to_json

  end

  def account_data_collect(ibans)
    ibans.each do |iban|
      @browser.link(href: '/EBank/accounts/details/' + iban).click
      sleep(0.2)

      @accounts << {
          name: @browser.h4(:css, 'h4[ng-bind="model.acc.acDesc"]').text,
          currency: @browser.dd(index: 1).text,
          balance: @browser.h3(class: %w[blue-txt ng-binding ng-scope]).text.gsub(/\s+/, '').to_f,
          nature: @browser.dd(index: 3).text,
          transactions: transactions_quantity_collect(iban)
      }
      sleep(0.2)
      @browser.link(href: '/EBank/accounts').click
    end

  end

  def transactions_quantity_collect(iban)
    sleep(0.2)
    @browser.link(href: '/EBank/accounts/statement/' + iban).click
    @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.strftime('%d/%m/') + '2010')
    @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click
    @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).text
  end


end
