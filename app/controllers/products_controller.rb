class ProductsController < ApplicationController
  def index
    @products = Product.includes(:categories).order(created_at: :desc)

    if params[:filter].present?
      case params[:filter]
      when "sale"
        @products = @products.on_sale
      when "new"
        @products = @products.new_arrivals
      when "recent"
        @products = @products.recently_updated
      end
    end

    if params[:keyword].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
