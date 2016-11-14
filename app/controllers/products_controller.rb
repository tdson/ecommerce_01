class ProductsController < ApplicationController
  before_action :load_category
  def index
    @categories = Category.all
    @main_categories = Category.main_category
    @products = Product.recent.page(params[:page]).
      per Settings.products_per_page
  end
end
