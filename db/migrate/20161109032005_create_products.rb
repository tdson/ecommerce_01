class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.references :category, foreign_key: true
      t.string :name
      t.string :description
      t.string :image
      t.integer :price
      t.integer :quantity

      t.timestamps
    end

    add_index :products, :name
  end
end
