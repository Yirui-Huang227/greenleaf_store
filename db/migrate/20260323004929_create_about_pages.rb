class CreateAboutPages < ActiveRecord::Migration[7.1]
  def change
    create_table :about_pages do |t|
      t.string :title, null: false
      t.text :about
      t.text :contact
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
