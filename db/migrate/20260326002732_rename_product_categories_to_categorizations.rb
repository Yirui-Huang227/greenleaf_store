class RenameProductCategoriesToCategorizations < ActiveRecord::Migration[7.1]
  def change
    rename_table :product_categories, :categorizations
  end
end
