class Admin::OrderProductsController < ApplicationController
  before_action :load_order_product

  def update
    original_qty = @order_product.quantity
    amount = original_qty - params[:quantity].to_i
    if @order_product.update_attributes(update_params) &&
      @order_product.product.update_quantity(amount)
      flash.now[:success] = t ".success"
      total_cost = @order_product.order.total_cost
      respond Settings.html_status[:success],
        [to_currency(total_cost), original_qty]
    else
      error_mgs = @order_product.errors
        .full_messages
        .join(Settings.js_line_break)
        .html_safe
      flash.now[:danger] = error_mgs
      respond Settings.html_status[:bad_request], [error_mgs, original_qty]
    end
  end

  def destroy
    if @order_product.give_back && @order_product.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fails"
    end
    redirect_to edit_admin_order_path @order_product.order
  end

  private
  def update_params
    params.permit :id, :quantity
  end

  def load_order_product
    @order_product = OrderProduct.find_by_id params[:id]
    unless @order_product
      flash[:danger] = t "admin.order_products.load_fails"
      redirect_to admin_orders_path(status: Settings.order_status[:pending])
    end
  end

  def respond status_code, response_data
    respond_to do |format|
      format.html {redirect_to edit_admin_order_path @order_product.order}
      format.json {render json: response_data.to_json, status: status_code}
    end
  end
end
