class AddIsReadToTableSuggestions < ActiveRecord::Migration[5.0]
  def change
    add_column :suggestions, :is_read, :boolean, default: false
  end
end
