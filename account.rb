require_relative 'require'

class Account

  include RequireDependencies

  def initialize(browser, headless)
    @browser = Watir::Browser.new browser, headless: headless
  end

  def open(goto)

    @browser.goto goto

  end

  def collect
    @browser.link(id: 'demo-link').click
    @browser.link(href: '/EBank/accounts').click

    sleep(1)

    @accounts = []
    divs = @browser.divs(class: %w[display-inl-block bg-circle-acc])
    divs.each do |div|
      @accounts << div.link.text
    end
    @arr = []
    @accounts.each do |account_link|
      @browser.link(href: '/EBank/accounts/details/' + account_link).click

      sleep(2)

      @arr << @browser.h4(:css, 'h4[ng-bind="model.acc.acDesc"]').text # name
      @arr << @browser.dd(index: 1).text # currency
      @arr << @browser.h3(class: %w[blue-txt ng-binding ng-scope]).text # balance
      @arr << @browser.dd(index: 3).text # nature

      sleep(1)

      # transactions
      @browser.link(href: '/EBank/accounts/statement/' + account_link).click
      @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.strftime('%d/%m/') + '2010')
      @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click

      @arr << @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).text # transactions quantity
      sleep(0.5)

      @browser.link(href: '/EBank/accounts').click

    end

    puts @arr

  end


end
