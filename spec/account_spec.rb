require 'rspec'
require_relative '../lib/account'
require_relative '../lib/browser'
require_relative '../modules/require'

RSpec.describe Account do

  let(:account) { Account.new(:firefox, true) }

  it 'Getting JSON response' do
    @accounts = { accounts: [] }
    @account.to_json
    expect(account.collect).to be @account
  end

end
