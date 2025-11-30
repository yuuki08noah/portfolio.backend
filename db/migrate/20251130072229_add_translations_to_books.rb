class AddTranslationsToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :title_ko, :string
    add_column :books, :author_ko, :string
    add_column :books, :review_ko, :text
  end
end
