class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.includes(:categories).distinct

    # special product filters
    if params[:filter].present?
      case params[:filter]
      when "sale"
        @products = @products.where(on_sale: true)
        @page_title = "On Sale Products"
      when "new"
        @products = @products.where("products.created_at >= ?", 3.days.ago)
        @page_title = "New Products"
      when "recent"
        @products = @products.where("products.updated_at >= ?", 3.days.ago)
                            .where("products.created_at < ?", 3.days.ago)
        @page_title = "Recently Updated Products"
      else
        @page_title = "All Products"
      end
    end

    # keyword search
    if params[:keyword].present?
      keyword = "%#{params[:keyword].strip}%"
      @products = @products.where(
        "products.name LIKE :keyword OR products.description LIKE :keyword",
        keyword: keyword
      )
    end

    # category filter
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
