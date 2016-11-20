class ProductsController < ApplicationController
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

    @products = @products_full.page(params[:page]).
      per Settings.products_per_page
  end
end
