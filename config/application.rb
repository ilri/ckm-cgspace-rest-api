require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CgspaceRestApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # CGSpace URL base for handle
    config.base_handle_url = 'https://cgspace.cgiar.org/handle/'

    # CGSpace URL base for thumbnail
    config.base_thumbnail_url = 'https://cgspace.cgiar.org/bitstream/handle/'

    # CGSpace URL for default thumbnail
    config.default_thumbnail_url = 'https://cgspace.cgiar.org/themes/0_CGIAR/images/fallback-mimetypes/application-x-zerosize.svg'

    # DSpace Metadata Constants
    config.x.BITSTREAM = 0
    config.x.BUNDLE = 1
    config.x.ITEM = 2
    config.x.COLLECTION = 3
    config.x.COMMUNITY = 4
    config.x.SITE = 5
    config.x.GROUP = 6
    config.x.EPERSON = 7

    # Default Options
    config.x.LIMIT = 20
    config.x.PAGE = 1
    config.x.ORDER = 'item_id desc'

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get]
      end
    end

    #ActiveModelSerializers.config.adapter = :json_api
  end
end
