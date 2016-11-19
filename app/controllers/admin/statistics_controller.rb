class Admin::StatisticsController < AdminController
  def index
    params[:range] ||= Statistic.default_range
    @orders = Order.quantity_within(params[:range])
      .map {|order| [order.date, order.quantity]}
    @products = Product.top_product_within(params[:range], Settings.top_product)
      .map {|product| [product.name, product.quantity]}
    respond_to do |format|
      format.html
      format.js
    end
  end
end
