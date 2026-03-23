class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.boolean :on_sale
      t.integer :quantity

      t.timestamps
    end
  end
end
