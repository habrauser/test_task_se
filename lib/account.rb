require_relative 'browser'

class Account < Browser

  def collect
    sleep(0.2)

    @ibans = []
    divs = @browser.divs(class: %w[display-inl-block bg-circle-acc])
    divs.each do |div|
      @ibans << div.link.text
    end

    @accounts = []

    account_data_collect(@ibans)

    @accounts = { accounts: @accounts }

    puts @accounts.to_json
    @browser.close
  end

  def transactions_quantity_collect(iban)
    sleep(0.2)
    @browser.link(href: '/EBank/accounts/statement/' + iban).click
    @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.strftime('%d/%m/') + '2010')
    @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click
    @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).text
  end

  private

  def account_data_collect(ibans)
    ibans.each do |iban|
      @browser.link(href: '/EBank/accounts/details/' + iban).click
      sleep(0.2)

      @accounts << {
          name: @browser.h4(:css, 'h4[ng-bind="model.acc.acDesc"]').text,
          balance: @browser.h3(class: %w[blue-txt ng-binding ng-scope]).text.gsub(/\s+/, '').to_f,
          currency: @browser.dd(index: 1).text,
          nature: @browser.dd(index: 3).text,
          transactions_quantity: transactions_quantity_collect(iban).to_i
      }
      sleep(0.2)
      @browser.link(href: '/EBank/accounts').click
    end
  end



end
