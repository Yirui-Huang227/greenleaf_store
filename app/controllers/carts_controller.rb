class CartsController < ApplicationController
  before_action :initialize_cart

  def show
    @cart_items = load_cart_items
  end

  def add
    product_id = params[:product_id].to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += 1

    redirect_to cart_path, notice: "Product added to cart."
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    redirect_to cart_path, notice: "Cart updated."
  end

  def remove
    product_id = params[:product_id].to_s
    session[:cart].delete(product_id)

    redirect_to cart_path, notice: "Product removed from cart."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_cart_items
    product_ids = session[:cart].keys
    products = Product.where(id: product_ids).index_by(&:id)

    session[:cart].map do |product_id, quantity|
      product = products[product_id.to_i]
      next unless product

      {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
    end.compact
  end
end
