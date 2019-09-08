require_relative 'browser'

class Account < Browser

  def collect

    @ibans = []

    @accounts_page = Nokogiri::HTML.parse(@browser.html)
    @accounts_page.xpath('//a[@class="s1"]/span[@class="ng-binding"]').each do |iban|
      @ibans << iban.text
    end

    @accounts = []

    account_data_collect(@ibans)

    @accounts = { accounts: @accounts }

    puts @accounts.to_json

  end

  private

  def account_data_collect(ibans)
    ibans.each do |iban|
      @browser.a(href: '/EBank/accounts/details/' + iban).click
      sleep(3)
      @account_details = Nokogiri::HTML.parse(@browser.html)

      @accounts << {
          name: @account_details.xpath('//h4[@ng-bind="model.acc.acDesc"]').text,
          balance: @account_details.xpath('//h3[@class="blue-txt ng-binding ng-scope"]').text.gsub(/\s+/, '').to_f,
          currency: @account_details.xpath('//dd[@ng-bind="model.acc.ccy"]').text,
          nature: @account_details.xpath('//dd[@ng-bind="model.custAcc.ibRoleId"]').text,
          transactions_quantity: transactions_quantity_collect(iban).to_i,
          transactions: transactions_data_collect
      }
      @browser.link(href: '/EBank/accounts').click

    end
  end

  def transactions_quantity_collect(iban)

    @browser.link(href: '/EBank/accounts/statement/' + iban).click
    @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.prev_month(2).strftime('%d/%m/%Y')) #Last 2 months
    @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click
    sleep(1)
    @transactions_page = Nokogiri::HTML.parse(@browser.html)

    if @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).exist?
      @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).text
    else
      0
    end

  end


  def transactions_data_collect
    @transactions = []
    @table = @transactions_page.xpath('//table[@id="accountStatements"]/tbody')
    if @browser.span(:css, 'span[translate="PAGES.COMMON.NO_ITEMS"]').exist?
      @transactions << { info: 'There are no transactions on this account yet' }
    else
      @table.xpath('//tr[@id="step1"]').each do |cell|
        @transactions << {
          date: cell.css('td[1] > div > span').text,
          description: cell.css('td[5] > div > span').text,
          amount: cell.css('td[3] > div > span').text.to_f.positive? ? cell.css('td[3] > div > span').text.to_f - (cell.css('td[3] > div > span').text.to_f * 2) : cell.css('td[4] > div > span').text.to_f,
          currency: @transactions_page.xpath('//span[@class="filter-option"]').first.text[24..26],
          account_name: @transactions_page.xpath('//span[@class="filter-option"]').first.text[29..]
        }
      end
      @transactions
    end
  end



end
