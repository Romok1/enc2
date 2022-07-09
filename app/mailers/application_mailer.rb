class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:mailer, :username)
  layout 'mailer'
end
