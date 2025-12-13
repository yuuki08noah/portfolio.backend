# backend/reproduce_hire.rb
puts "--- Reproduction Script Start ---"

# 1. Print Config
puts "ActionMailer Config:"
puts "  Delivery Method: #{Rails.application.config.action_mailer.delivery_method}"
puts "  Raise Delivery Errors: #{Rails.application.config.action_mailer.raise_delivery_errors}"
puts "  SMTP Settings: #{Rails.application.config.action_mailer.smtp_settings}"

# 2. Define Params
hire_params = {
  name: "Test User",
  company: "Test Corp",
  email: "test@example.com",
  message: "I want to hire you.",
  schedule_iso: Time.now.iso8601
}

puts "\n[Simulating Submit Action]"
hire_request = HireRequest.new(hire_params)

if hire_request.save
  puts "HireRequest saved successfully. ID: #{hire_request.id}"
  
  puts "Dispatching email..."
  begin
    HireMailer.new_request(hire_request).deliver_now
    puts "Email delivered (no error raised)."
    hire_request.update(status: 'sent')
  rescue => e
    puts "Email delivery FAILED: #{e.class} - #{e.message}"
    hire_request.update(status: 'failed')
  end
  
  puts "Final Status: #{hire_request.status}"
  
  # Check if email is in deliveries (if :test method)
  if ActionMailer::Base.delivery_method == :test
    puts "Deliveries count: #{ActionMailer::Base.deliveries.count}"
    puts "Last email subject: #{ActionMailer::Base.deliveries.last&.subject}"
  end
  
  # Clean up
  hire_request.destroy
else
  puts "ERROR: Failed to save hire request: #{hire_request.errors.full_messages}"
end

puts "--- Reproduction Script End ---"
