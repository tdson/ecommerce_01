class ProductsController < ApplicationController
  before_action :load_product, only: :show

  def index
  end

  def show
    @cart_size = count_current_item
  end

  private
  def load_product
    @product = Product.includes(:category).with_average_rating(params[:id]).first
    unless @product
      flash[:warning] =  t "products.load_fails"
      return render_404
    end
  end
end
