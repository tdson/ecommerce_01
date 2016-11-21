class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :load_product_rating, only: :show
  before_action :load_category

  def index
    params[:condition] ||= Settings.product_filters[:get_all]
    @categories = Category.all
    @products_full = Product.includes(:category, :ratings)
      .search_product_or_category(params[:search])
      .of_category(params[:category_id])
      .alphabet

    if params[:condition] == Settings.product_filters[:price_decrease]
      @products_full = Product.includes(:category, :ratings).price_decrease
    end
    if params[:condition] == Settings.product_filters[:price_increase]
      @products_full = Product.includes(:category, :ratings).price_increase
    end

    if params[:condition] == Settings.product_filters_rating[:highest_rate]
      @products_full = Product.includes(:ratings)
    end

    @products = @products_full.page(params[:page])
      .per Settings.products_per_page
  end

  def show
    recent_products.push @product
  end

  private
  def load_product
    @product = Product.includes(:category).find_by_id params[:id]
    unless @product
      render_404
    end
  end

  def load_product_rating
    @rating = Rating.average_of @product.id
  end
end
