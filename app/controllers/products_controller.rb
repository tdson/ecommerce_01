class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :load_product_rating, only: :show

  def index
    @products = Product.search(params[:q]).recent.page(params[:page])
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
    @rating = Settings.no_rating if @rating.count_rating == Settings.zero
  end
end
