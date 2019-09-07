# to execute this script run 'ruby main.rb'

require_relative 'modules/require'

require_relative 'lib/account'


@browser = :firefox
@headless = true
@open = 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'

@account = Account.new(@browser, @headless)
@account.open(@open)
@account.collect
