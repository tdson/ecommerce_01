class CartsController < ApplicationController
  before_action :verify_product, only: :create

  def index
    @cart = session[:cart] ? session[:cart] : Hash.new
    @products = @cart.map {|id, quantity| [Product.find_by(id: id), quantity]}
  end

  def new
    session[:cart] = nil
    count_cart_size
    redirect_to action: :index
  end

  def create
    id = params[:product_id]
    session[:cart] ||= Hash.new
    cart = session[:cart]
    cart[id] = cart[id] ? (cart[id] + @quantity_request) : @quantity_request
    count_cart_size
    respond
  end

  def destroy
    session[:cart].delete params[:id]
    count_cart_size
    redirect_to action: :index
  end

  private
  def verify_product
    @product = Product.find_by_id params[:product_id]
    return render_404 unless @product
    quantity_remaining = @product.quantity
    @quantity_request = params[:quantity].to_i
    if quantity_remaining < @quantity_request ||
      @quantity_request < Settings.minimum_quantity
      flash[:warning] = t "carts.not_enough", qty: quantity_remaining
      redirect_to @product
    end
  end

  def respond
    respond_to do |format|
      format.html {redirect_to @product}
      format.js
    end
  end
end
