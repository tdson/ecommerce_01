class ModelMailer < ApplicationMailer
  def new_order_created order
    @order = order
    mail to: @order.user.email, subject: t(".subject")
  end
end
