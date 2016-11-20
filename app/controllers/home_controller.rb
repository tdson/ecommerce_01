class HomeController < ApplicationController
  def index
    @new_products = Product.top_new Settings.top_new_limit
    @hot_trend_products = Product.hot_trend(Settings.date_range[:one_month],
      Settings.hot_trend_limit)
  end
end
