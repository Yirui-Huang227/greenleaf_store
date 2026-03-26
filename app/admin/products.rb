ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :on_sale, :quantity
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :on_sale, :quantity]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :name, :description, :price, :on_sale, :quantity, category_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :quantity
    column :on_sale
    column("Categories") { |product| product.categories.map(&:name).join(", ") }
    column :created_at
    actions
  end

  filter :name
  filter :price
  filter :on_sale
  filter :quantity
  filter :categories_name, as: :string, label: "Category"
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :quantity
      f.input :on_sale
      f.input :categories, as: :check_boxes
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row :quantity
      row :on_sale
      row("Categories") { |product| product.categories.map(&:name).join(", ") }
      row :created_at
      row :updated_at
    end
  end
end
