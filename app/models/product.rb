class Product < ApplicationRecord
  belongs_to :category
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :ratings, dependent: :destroy
  has_many :ratings, -> {order :rating}

  validates :price, numericality: true, allow_nil: true
  validates :quantity, numericality: true, allow_nil: true
  validates :name, presence: true

  scope :recent, ->{order created_at: :DESC}
  scope :alphabet, ->{order :name}
  mount_uploader :image, ProductImageUploader

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
      when ".csv" then Roo::Csv.new(file.path, packed: false, file_warning: :ignore)
      when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
