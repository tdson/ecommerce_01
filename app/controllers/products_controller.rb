class ProductsController < ApplicationController
  before_action :load_product, only: :show
  before_action :load_product_rating, only: :show

  def index
    @products = Product.recent.page(params[:page])
      .per Settings.products_per_page
  end

  def show
  end

  private
  def load_product
    @product = Product.includes(:category).find_by_id params[:id]
    unless @product
      render_404
    end
  end

  def load_product_rating
    @rating = Rating.average_of @product
  end
end
