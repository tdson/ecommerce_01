class ProductsController < ApplicationController
  def index
    @products = Product.recent.page(params[:page]).
      per Settings.products_per_page
  end
end
