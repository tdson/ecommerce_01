class AddParentIdToCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :parent_id, :integer, null: true, index: true
    rename_column :categories, :left_node, :lft
    rename_column :categories, :right_node, :rgt
  end
end
