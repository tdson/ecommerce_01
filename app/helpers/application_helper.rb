module ApplicationHelper
  def full_title page_title = ""
    base_title = t ".base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def count_current_item
    @cart_size = 0
    if session[:cart]
      session[:cart].each do |key, val|
        @cart_size += val
      end
    end
    @cart_size
  end

  def total_cost products
    @total = 0
    products.each do |product, qty|
      @total += product.price * qty
    end
    @total
  end

  def to_currency number
    "#{t 'currency'}%.2f" % number
  end
end
