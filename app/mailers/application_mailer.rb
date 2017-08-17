# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'learning@leb-dev.com'
  layout 'mailer'
end
