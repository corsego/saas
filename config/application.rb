require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Saascorsego
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    # Permitted locales available for the application
    I18n.available_locales = [:en, :es, :ru]

    # Set default locale to something other than :en
    I18n.default_locale = :en

    config.time_zone = "UTC"
  end
end
