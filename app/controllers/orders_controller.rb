class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart, only: [:new, :create]
  before_action :load_order, only: :update
  before_action :check_cancelable, only: :update
  before_action :update_product_quantity, only: :update

  def new
    @order = Order.new
  end

  def create
    Order.set_session_cart @cart
    @order = current_user.orders.create order_params
    if @order.save
      session[:cart] = nil
      order_full = Order.includes(:user, order_products: :product)
        .find @order.id
      ModelMailer.new_order_created(order_full).deliver

      flash[:success] = t ".success"
      redirect_to root_path
    else
      flash[:danger] = t ".fails"
      render :new
    end
  end

  def update
    if @order.update_attribute :status, Settings.order_status[:canceled]
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fails"
    end
    redirect_to :back || root_path
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

  def load_order
    @order = Order.find_by_id params[:id]
    unless @order
      flash[:danger] = t "orders.load_fails"
      redirect_to root_path
    end
  end

  def check_cancelable
    unless @order.status == Settings.order_status_in_word[:pending]
      flash[:warning] = t "orders.update.cannot_cancel"
      redirect_to :back || root_path
    end
  end

  def update_product_quantity
    unless @order.give_product_back
      flash[:danger] = t "orders.update.cancel_fails"
      redirect_to :back || root_path
    end
  end
end
