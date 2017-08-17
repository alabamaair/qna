# frozen_string_literal: true
# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  address: 'smtp.yandex.ru',
  port: 25,
  user_name: ENV['MAILER_EMAIL'],
  password: ENV['MAILER_PASSWORD'],
  authentication: :plain
}
