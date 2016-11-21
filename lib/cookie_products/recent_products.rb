class RecentProducts < CookieCollection
  def initialize cookies
    super cookies
    self.ids = ids.last Settings.recent_products_size
    ids.each {|product_id| push Product.find_by_id(product_id)}
  end

  def push product
    delete product
    while length > Settings.recent_products_size - 1
      delete_at 0
    end
    super product
  end
end
