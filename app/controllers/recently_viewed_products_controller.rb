class RecentlyViewedProductsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @products = recent_products.reverse
  end
end
