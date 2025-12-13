class AddFeaturedToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :featured, :boolean, default: false, null: false
    add_index :projects, :featured
  end
end
