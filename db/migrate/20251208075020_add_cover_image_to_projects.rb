class AddCoverImageToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :cover_image, :string
  end
end
