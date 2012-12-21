require "airbrake"
require_relative "../lib/initializers"
require_relative "../lib/nongovuk_reach_collector"

module DataInsight
  module Collector
    def self.options
      {
          metric: "metric to collect",
          site: "the site",
          authorization_code: "authorization code"
      }
    end

    def self.collector(options)
      Collectors::NongovukReachCollector.new(options[:site], options[:metric], options[:authorisation_code])
    end

    def self.queue_name(options)
      "datainsight"
    end

    def self.queue_routing_key(options)
      "google_drive.#{options[:metric]}.weekly"
    end

    def self.handle_error(error)
      Airbrake.notify(error)
    end
  end
end