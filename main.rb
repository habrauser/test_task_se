# to execute this script run 'ruby main.rb'

require_relative 'account'

@account = Account.new(:firefox, false)
@account.open('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK')
@account.collect