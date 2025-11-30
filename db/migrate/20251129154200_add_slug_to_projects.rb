class AddSlugToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :slug, :string
    add_column :projects, :deleted_at, :datetime
    
    add_index :projects, :slug, unique: true
    add_index :projects, :deleted_at

    # Rename columns to match model expectations
    rename_column :projects, :demo_link, :demo_url
    rename_column :projects, :repo_link, :repo_url
  end
end
