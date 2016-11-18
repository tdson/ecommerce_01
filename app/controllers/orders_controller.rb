class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart, only: [:new, :create]
  before_action :load_user, only: :index
  before_action :verify_user, only: :index

  def index
    @orders = @user.orders.recent
      .page(params[:page])
      .per Settings.products_per_page
  end

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

  private
  def order_params
    params.permit :full_name, :phone, :shipping_address
  end

  def check_cart
    @cart = session[:cart]
    unless @cart
      flash[:danger] = t "orders.empty_cart"
      redirect_to root_path
    end
  end

  def send_receipt_to_mail
    order = Order.includes(:user, :order_products).find self.id
    ModelMailer.new_order_created(order).deliver
  end

  def load_user
    @user = User.find_by_id params[:user_id]
    unless @user
      flash[:danger] = t "orders.user_not_found"
      redirect_to :back || root_path
    end
  end

  def verify_user
    unless current_user.is_user? @user
      redirect_to :back || user_orders_url(current_user)
    end
  end
end
