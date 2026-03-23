class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :order_province_id
      t.string :order_address
      t.string :order_city
      t.string :order_postal_code
      t.string :status
      t.decimal :subtotal
      t.decimal :gst_rate
      t.decimal :pst_rate
      t.decimal :hst_rate
      t.decimal :gst_amount
      t.decimal :pst_amount
      t.decimal :hst_amount
      t.decimal :total
      t.string :stripe_payment_id

      t.timestamps
    end
  end
end
