# backend/reproduce_issue.rb
# Usage: bin/rails runner reproduce_issue.rb

puts "--- Reproduction Script Start ---"

# 1. Setup User
user = User.first
unless user
  user = User.create!(
    email: "repro_#{Time.now.to_i}@example.com",
    password: "password123",
    name: "Repro User",
    role: :admin # Ensure admin if needed, though controller just checks authenticate_user!
  )
  puts "Created user: #{user.email}"
else
  puts "Using existing user: #{user.email}"
end

# 2. Define Params
book_params = {
  title: "Test Book #{Time.now.to_i}",
  author: "Test Author",
  status: "to-read",
  rating: 3
}

translations_params = {
  "ko" => { "title" => "테스트 책", "author" => "테스트 저자", "review" => "리뷰 확인" },
  "ja" => { "title" => "テスト本", "author" => "テスト著者", "review" => "レビュー確認" }
}

# 3. Simulate Controller Logic (CREATE)
puts "\n[Simulating Create Action]"
book = user.books.new(book_params)

if book.save
  puts "Book saved successfully. ID: #{book.id}"
  
  # Current Logic in Controller:
  # save_translations(book)
  
  # Logic of save_translations:
  %w[ko ja].each do |locale|
    if translations_params[locale].present?
      t_params = translations_params[locale] # In controller it permits params
      book.set_translations(locale, t_params)
    end
  end
  
  # NOTE: We are now simulating the FIXED controller logic.
  book.save
  
  puts "Translations set (in memory) and book.save called."
  
  # Reload to check DB
  book.reload
  
  ko_trans = Translation.where(translatable: book, locale: 'ko').count
  ja_trans = Translation.where(translatable: book, locale: 'ja').count
  
  puts "Translations in DB (KO): #{ko_trans}"
  puts "Translations in DB (JA): #{ja_trans}"
  
  if ko_trans > 0 && ja_trans > 0
    puts "SUCCESS: Translations were saved."
  else
    puts "FAILURE: Translations were NOT saved."
  end
  
  # Cleanup
  book.destroy
else
  puts "ERROR: Failed to save book: #{book.errors.full_messages}"
end

puts "\n--- Reproduction Script End ---"
