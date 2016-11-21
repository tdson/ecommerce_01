class Admin::OrdersController < AdminController
  before_action :load_order, only: [:destroy, :update]
  before_action :check_updateable, only: :update
  before_action :sanitize_params, only: :update

  def index
    @orders = Order.with_status(params[:status])
      .search(params[:q])
      .sort_by_recently
      .page(params[:page])
      .per Settings.order_per_page
  end

  def edit
    @order = Order.includes(order_products: :product).find_by_id params[:id]
  end

  def update
    if @order.update_attributes order_params
      flash[:success] = t ".success"
      if @order.is_accepted? &&
        (order_full = Order.includes(:user, order_products: :product)
          .find_by_id @order.id)
        UserMailer.order_accepted(order_full).deliver
      end
    else
      error_mgs = @order.errors
        .full_messages
        .join(Settings.line_break)
        .html_safe
      flash[:danger] = error_mgs || t(".fails")
    end
    redirect_to :back || root_path
  end

  def destroy
    if @order.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fails"
    end
    redirect_to admin_orders_path status: params[:status]
  end

  private
  def load_order
    @order = Order.find_by_id params[:id]
    unless @order
      flash[:danger] = t "admin.orders.load_fails"
      redirect_to admin_orders_path status: params[:status]
    end
  end

  def sanitize_params
    status = params[:order][:status].to_i
    if !@order.is_pending? && status == Settings.order_status[:canceled]
      flash[:warning] = t "orders.update.cannot_cancel"
      redirect_to :back || root_path
    else
      params[:order][:status] = status
    end
  end

  def order_params
    params.require(:order)
      .permit :full_name, :phone, :shipping_address, :status,
        order_products_attributes: [:id, :quantity]
  end

  def check_updateable
    unless @order.is_pending?
      flash[:warning] = t "orders.update.cannot_update"
      redirect_to edit_admin_order_path(@order)
    end
  end
end
