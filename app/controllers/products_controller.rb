class ProductsController < ApplicationController
  def index
    @products = Product.includes(:categories).order(created_at: :desc)

    if params[:keyword].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
