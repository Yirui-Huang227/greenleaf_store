class ApplicationController < ActionController::Base
  before_action :load_categories

  private

  def load_categories
    @categories = Category.order(:name)
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

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
