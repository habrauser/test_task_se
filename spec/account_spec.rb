require 'rspec'
require_relative '../lib/account'
require_relative '../lib/browser'
require_relative '../modules/require'

@accounts = { account: [] }

describe 'collect' do
  it "is equal to another string of the same value" do
    expect(Account.new(:firefox, true).collect).to eq(@accounts)
  end
  end