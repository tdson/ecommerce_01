class ProductImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/assets/" + [version_name, "product_default.jpg"].compact.join("_")
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
