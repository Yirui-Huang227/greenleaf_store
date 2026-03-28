ActiveAdmin.register Province do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :code, :gst, :pst, :hst
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :code, :gst, :pst, :hst]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :name, :code, :gst, :pst, :hst

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :gst
    column :pst
    column :hst
    column :created_at
    actions
  end

  filter :name
  filter :code
  filter :gst
  filter :pst
  filter :hst
  filter :created_at

  show do
    attributes_table do
      row :id
      row :name
      row :code
      row :gst
      row :pst
      row :hst
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :code
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end
end
