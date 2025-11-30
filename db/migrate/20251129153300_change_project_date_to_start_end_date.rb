class ChangeProjectDateToStartEndDate < ActiveRecord::Migration[8.1]
  def change
    # Add new columns
    add_column :projects, :start_date, :date
    add_column :projects, :end_date, :date
    add_column :projects, :is_ongoing, :boolean, default: false, null: false

    # Migrate existing data
    reversible do |dir|
      dir.up do
        Project.reset_column_information
        Project.find_each do |project|
          if project.date.present?
            project.update_columns(start_date: project.date, end_date: project.date, is_ongoing: false)
          end
        end
      end
    end

    # Remove old column
    remove_column :projects, :date, :date
  end
end
