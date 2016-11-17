module CartsHelper
  def cart_page_title
    cart_size = count_cart_size
    cart_size == Settings.empty_cart ? t("carts.index.title_empty") :
      t("carts.index.title", qty: cart_size)
  end

  def cart_total_cost items
    items.inject(0){|sum, item| sum + (item[0].price * item[1])}
  end

  def count_cart_size
    if session[:cart]
      session[:cart].inject(0){|sum, item| sum + item[1]}
    else
      Settings.empty_cart
    end
  end
end
