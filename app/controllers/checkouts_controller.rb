class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cart_not_empty
  before_action :ensure_user_has_address

  def show
    load_checkout_data
  end

  private

  def load_checkout_data
    @cart = session[:cart] || {}

    @cart_items = Product.where(id: @cart.keys).map do |product|
      quantity = @cart[product.id.to_s].to_i
      {
        product: product,
        quantity: quantity,
        line_total: product.price.to_f * quantity
      }
    end

    @subtotal = @cart_items.sum { |item| item[:line_total] }

    province = current_user.province

    @gst_rate = province.gst.to_f
    @pst_rate = province.pst.to_f
    @hst_rate = province.hst.to_f

    @gst_amount = @subtotal * (@gst_rate / 100)
    @pst_amount = @subtotal * (@pst_rate / 100)
    @hst_amount = @subtotal * (@hst_rate / 100)

    @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
  end

  def ensure_cart_not_empty
    redirect_to cart_path, alert: "Your cart is empty." if session[:cart].blank?
  end

  def ensure_user_has_address
    if current_user.address.blank? || current_user.city.blank? || current_user.postal_code.blank? || current_user.province.blank?
      redirect_to edit_user_registration_path, alert: "Please complete your address before checkout."
    end
  end
end
