class CreateProjectBlogPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :project_blog_posts do |t|
      t.references :project, foreign_key: true, null: false
      t.string :category, null: false
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false
      t.integer :order, default: 0
      t.string :velog_url
      t.string :velog_post_id
      t.integer :velog_likes, default: 0
      t.integer :velog_comments, default: 0
      t.integer :velog_views, default: 0
      t.datetime :velog_synced_at
      t.timestamps
    end
    
    add_index :project_blog_posts, [:project_id, :category, :slug], unique: true, name: 'index_project_blog_posts_unique'
    add_index :project_blog_posts, :project_id
    add_index :project_blog_posts, :category
  end
end
