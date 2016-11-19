class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart, only: [:new, :create]
  before_action :load_user, only: :index
  before_action :verify_user, only: :index
  before_action :load_order, only: :update
  before_action :check_cancelable, only: :update
  before_action :update_product_quantity, only: :update

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
        .find_by_id @order.id
      if order_full
        ModelMailer.new_order_created(order_full).deliver
      else
        flash[:warning] = t ".warning"
      end
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
      flash[:danger] = t "orders.empty_cart"
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
    unless @order.is_pending?
      flash[:warning] = t "orders.update.cannot_cancel"
      redirect_to :back || root_path
    end
  end

  def load_user
    @user = User.find_by_id params[:user_id]
    unless @user
      flash[:danger] = t "orders.user_not_found"
      redirect_to :back || root_path
    end
  end

  def update_product_quantity
    unless @order.give_product_back
      flash[:danger] = t "orders.update.cancel_fails"
      redirect_to :back || root_path
    end
  end

  def verify_user
    unless current_user.is_user? @user
      redirect_to :back || user_orders_url(current_user)
    end
  end
end
