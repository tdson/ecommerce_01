class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart

  def new
    @order = Order.new
  end

  def create
    Order.set_session_cart @cart
    @order = current_user.orders.create order_params
    if @order.save
      session[:cart] = nil
      order_full = Order.includes(:user, order_products: :product)
        .find_by_id @order.id
      UserMailer.new_order_created(order_full).deliver
      flash[:success] = t ".success"
      redirect_to root_path
    else
      flash[:danger] = t ".fails"
      render :new
    end
  end

  private
  def order_params
    params.permit :full_name, :phone, :shipping_address
  end

  def check_cart
    @cart = session[:cart]
    unless @cart
      flash[:danger] = t ".empty_cart"
      redirect_to root_path
    end
  end
end
