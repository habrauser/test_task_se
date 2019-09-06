require_relative 'browser'

class Transaction < Browser

  def collect

    sleep(0.2)

    @ibans = []
    divs = @browser.divs(class: %w[display-inl-block bg-circle-acc])
    divs.each do |div|
      @ibans << div.link.text
    end

    @transactions = []

    transactions_data_collect(@ibans)

    @transactions = { transactions: @transactions }

    puts @transactions.to_json
  end

  private

  def transactions_data_collect(ibans)


    ibans.each do |iban|
    @browser.link(href: '/EBank/accounts/statement/' + iban).click
    @browser.text_field(class: 'form-control ng-isolate-scope').set(DateTime.now.strftime('%d/%m/') + '2010')
    @browser.button(:css, 'button[translate="PAGES.ACCOUNT_STATEMENT.BUTTON"]').click


    @browser.table(:id, 'accountStatements').tbody.rows.each do |row|
      @transactions << {
          date: row.cell(index: 0).text,
          description: row.cell(index: 4).text,
          amount: row.cell(index: 2).text.to_f > 0 ? row.cell(index: 2).text.to_f - (row.cell(index: 2).text.to_f * 2) : row.cell(index: 3).text.to_f,
          currency: @browser.span(class: 'filter-option').text[23..25],
          account_name: @browser.span(class: 'filter-option').text[29..]
      }
    end

    sleep(0.2)
    @browser.link(href: '/EBank/accounts').click
      end

  end

end