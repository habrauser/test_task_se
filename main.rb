# to execute this script run 'ruby main.rb'

require_relative 'modules/require'

require_relative 'lib/account'
require_relative 'lib/transaction'

@browser = :firefox
@headless = false
@open = 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'



@transactions = Transaction.new(@browser, @headless)
@transactions.open(@open)
@transactions.collect
