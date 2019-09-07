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
          transactions_quantity: transactions_quantity_collect(iban).to_i,
          transactions: transactions_data_collect
      }
      sleep(0.2)
      @browser.link(href: '/EBank/accounts').click
    end
  end

  def transactions_quantity_collect(iban)
    sleep(0.2)
    @browser.link(href: '/EBank/accounts/statement/' + iban).click
    @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.prev_month(2).strftime('%d/%m/%Y'))
    sleep(0.2)
    @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click
    sleep(0.2)

    if @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).exist?
      @browser.span(class: %w[blue-txt bold ng-binding ng-scope]).text
    else
      0
    end

  end


  def transactions_data_collect
    @transactions = []
    sleep(0.2)
    if @browser.span(:css, 'span[translate="PAGES.COMMON.NO_ITEMS"]').exist?
      @transactions << { info: 'There are no transactions on this account yet' }
    else
      @browser.table(:id, 'accountStatements').tbody.rows.each do |row|
        sleep(0.2)
        @transactions << {
          date: row.cell(index: 0).text,
          description: row.cell(index: 4).text,
          amount: row.cell(index: 2).text.to_f.positive? ? row.cell(index: 2).text.to_f - (row.cell(index: 2).text.to_f * 2) : row.cell(index: 3).text.to_f,
          currency: @browser.span(class: 'filter-option').text[23..25],
          account_name: @browser.span(class: 'filter-option').text[29..]
        }
      end
      @transactions
    end
  end



end
