class CartsController < ApplicationController
  before_action :verify_product, only: :create

  def index
    @cart = session[:cart] ? session[:cart] : {}
    @products = @cart.map {|id, quantity| [Product.find_by(id: id), quantity]}
  end

  def create
    id = params[:product_id]
    session[:cart] = {} unless session[:cart]
    cart = session[:cart]
    cart[id] = cart[id] ? (cart[id] + @qty_request) : @qty_request
    count_current_item
    respond
  end

  def destroy
    session[:cart] = nil
    count_current_item
    redirect_to action: :index
  end

  def remove
    item = session[:cart].select {|key, val| key == params[:product_id]}
    item.map {|id, qty| session[:cart].delete id}
    count_current_item
    redirect_to action: :index
  end

  private
  def verify_product
    @product = Product.find_by_id params[:product_id]
    return render_404 unless @product
    if @product.sold_out?
      flash[:warning] = t "carts.sold_out"
      return redirect_to @product
    end
    qty_remaining = @product.quantity
    @qty_request = params[:quantity].to_i
    if (qty_remaining < @qty_request) || (@qty_request < Settings.minimum_qty)
      flash[:warning] = t "carts.not_enough", qty: qty_remaining
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
