class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_FROM_EMAIL', 'no-reply@example.com')
  layout "mailer"
end
