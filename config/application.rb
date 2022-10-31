require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Moscow"
    # config.eager_load_paths << Rails.root.join("extras")

    # ActiveStorage add new files
    config.active_storage.replace_on_assign_to_many = false

    # connect ActiveJob to sidekiq
    config.active_job.queue_adapter = :sidekiq

    config.autoload_paths += [config.root.join('app')]

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.generators do |g|
      g.test_framework :rspec,
                        controller_specs: true,
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false
    end
  end
end
