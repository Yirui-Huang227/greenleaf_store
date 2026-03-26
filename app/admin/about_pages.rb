ActiveAdmin.register AboutPage do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :about, :contact, :admin_user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :about, :contact, :admin_user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :title, :about, :contact

  index do
    selectable_column
    id_column
    column :title
    column :admin_user
    column :created_at
    actions
  end

  filter :title
  filter :admin_user
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :about
      f.input :contact
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :about
      row :contact
      row :admin_user
      row :created_at
      row :updated_at
    end
  end

  controller do
    def create
      @about_page = AboutPage.new(permitted_params[:about_page])
      @about_page.admin_user = current_admin_user
      create!
    end

    def update
      resource.admin_user = current_admin_user
      update!
    end
  end
end
