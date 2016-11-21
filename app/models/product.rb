class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, -> {order :rating}, dependent: :destroy
  delegate :name, to: :category, prefix: :category

  mount_uploader :image, ProductImageUploader

  validates :price, numericality: true, allow_nil: true
  validates :quantity, numericality: true, allow_nil: true
  validates :name, presence: true

  scope :recent, ->{order created_at: :DESC}
  scope :top_product_within, ->(range, limit) do
    joins(:order_products)
      .select("products.name, SUM(order_products.quantity) AS quantity")
      .where("order_products.created_at >=
        '#{Settings.date_range[range].days.ago}'")
      .group("products.name")
      .order("quantity desc")
      .limit limit
  end
  scope :top_new, ->limit do
    order(created_at: :desc)
      .limit limit
  end
  scope :hot_trend, ->date_range, limit do
    select("products.id, products.name, products.price, products.image")
      .joins(:order_products)
      .where("order_products.created_at >= '#{date_range.month.ago}'")
      .group("products.id")
      .order("COUNT(order_products.id) DESC")
      .limit limit
  end
  scope :search, ->q {where "products.name LIKE '%#{q}%'" if q.present?}
  scope :alphabet, ->{order :name}
  scope :search_product_or_category, ->(search) do
    joins(:category)
      .where "products.name LIKE :query OR categories.name LIKE :query",
        query: "%#{search}%" if search.present?
  end
  scope :of_category, ->category_id do
    where category_id: category_id if category_id.present?
  end
  scope :price_decrease, ->{order price: :DESC}
  scope :price_increase, ->{order price: :ASC}

  def sold_out?
    self.quantity < Settings.minimum_quantity
  end

  def update_quantity amount
    self.quantity += amount
    self.save
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by_id(row["id"]) || new
      product.attributes = row.to_hash.slice(*row.to_hash.keys)
      product.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv"
      Roo::Csv.new(file.path, packed: false, file_warning: :ignore)
    when ".xls"
      Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx"
      Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
    else
      raise "Unknown file type: #{file.original_filename}"
    end
  end
end
