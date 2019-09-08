require 'rspec'
require_relative '../lib/account'
require_relative '../lib/browser'
require_relative '../modules/require'

@accounts = { account: [] }

describe 'collect' do
  it 'Account data collects correct' do
    expect(Account.new(:firefox, true).collect).to eq(@accounts)
  end
  end