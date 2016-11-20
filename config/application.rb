require_relative "boot"

require "rails/all"
require "carrierwave"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ecommerce01
  class Application < Rails::Application
    config.eager_load_paths += %W(#{config.root}/lib/cookie_products)
    config.eager_load_paths += %W(#{config.root}/lib/statistics)
    config.eager_load_paths += %W(#{config.root}/lib/rating)
  end
end
