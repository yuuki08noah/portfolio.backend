class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :subtitle
      t.string :slug
      t.text :content
      t.text :excerpt
      t.string :cover_image
      t.text :tags
      t.integer :category_id
      t.integer :status
      t.datetime :published_at
      t.datetime :scheduled_at
      t.boolean :is_public
      t.integer :views

      t.timestamps
    end
  end
end
