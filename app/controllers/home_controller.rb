class HomeController < ApplicationController
  def index
    @featured_products = Product.order(updated_at: :desc).limit(8)
  end
end
