class UserMailer < ApplicationMailer
  def new_order_created order
    @order = order
    mail to: @order.user.email, subject: t(".subject")
  end

  def order_accepted order
    @order = order
    mail to: @order.user.email, subject: t(".subject")
  end
end
