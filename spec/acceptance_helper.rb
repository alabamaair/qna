require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma
  Capybara.server_port = 3001

  OmniAuth.config.test_mode = true

  config.include AcceptanceMacros, type: :feature
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end