class Admin::StatisticsController < AdminController
  def index
    @last_7_days_orders = Order.last_7_days_qty
    @top_product = Product.top_product Settings.limit_top_product
  end
end
