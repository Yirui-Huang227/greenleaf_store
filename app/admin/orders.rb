ActiveAdmin.register Order do
  permit_params :status

  includes :user, :order_items, :province

  filter :id
  filter :user
  filter :status
  filter :total
  filter :created_at

  index do
    selectable_column
    id_column
    column("Customer") { |order| order.user.email }
    column :status
    column("Products Ordered") do |order|
      order.order_items.map { |item| "#{item.product_name} x#{item.quantity}" }.join(", ")
    end
    column("Taxes") do |order|
      (order.gst_amount || 0) + (order.pst_amount || 0) + (order.hst_amount || 0)
    end
    column("Grand Total") { |order| order.total }
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row("Customer") { |order| order.user.email }
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
        column("Product") { |item| item.product_name }
        column("Unit Price") { |item| item.price_at_purchase }
        column :quantity
        column("Line Total") { |item| item.price_at_purchase * item.quantity }
      end
    end
  end

  form do |f|
    f.inputs "Order Status" do
      f.input :status, as: :select, collection: Order::STATUSES
    end
    f.actions
  end
end