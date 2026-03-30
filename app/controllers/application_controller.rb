class ApplicationController < ActionController::Base
  before_action :load_nav_categories, unless: :admin_namespace?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def load_nav_categories
    @nav_categories = Category.order(:name)
  end

  def admin_namespace?
    params[:controller].start_with?("admin/")
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :address, :city, :postal_code, :province_id
    ])

    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :address, :city, :postal_code, :province_id
    ])
  end
end
