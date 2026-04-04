ActiveAdmin.register Order do
  permit_params :status

  includes :user, :province, :order_items

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :subtotal
    column :total
    column :stripe_payment_id
    column :created_at
    actions
  end

  filter :id
  filter :user
  filter :status
  filter :created_at
  filter :total

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :subtotal
      row :gst_rate
      row :pst_rate
      row :hst_rate
      row :gst_amount
      row :pst_amount
      row :hst_amount
      row :total
      row :stripe_payment_id
      row :order_address
      row :order_city
      row :order_postal_code
      row("Province") { |order| order.province&.name }
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :product_name
        column :price_at_purchase
        column :quantity
        column("Line Total") { |item| item.price_at_purchase * item.quantity }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Order::STATUSES
    end
    f.actions
  end
end