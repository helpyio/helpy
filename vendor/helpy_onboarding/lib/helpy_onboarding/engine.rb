require 'deface'

module HelpyOnboarding
  class Engine < ::Rails::Engine
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      cache_klasses = %W(#{config.root}/app/**/*_decorator*.rb #{config.root}/app/overrides/*.rb)
      Dir.glob(cache_klasses) do |klass|
        Rails.configuration.cache_classes ? require(klass) : load(klass)
      end
    end

    config.assets.paths << File.expand_path("#{config.root}/assets/stylesheets/helpy_onboarding", __FILE__)
    config.assets.paths << File.expand_path("#{config.root}/assets/javascripts/helpy_onboarding", __FILE__)
    config.assets.precompile += %w( audits.scss )

    config.to_prepare(&method(:activate).to_proc)
  end
end
