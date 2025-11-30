class HireMailer < ApplicationMailer
  def new_request(hire_request)
    @hire_request = hire_request
    mail(
      to: ENV.fetch('HIRE_TO_EMAIL', 'noah8.technologies@proton.me'),
      subject: "New interview request from #{hire_request.name}"
    )
  end
end
