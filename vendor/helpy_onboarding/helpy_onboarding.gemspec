$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "helpy_onboarding/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "helpy_onboarding"
  s.version     = HelpyOnboarding::VERSION
  s.authors     = ["Scott Miller"]
  s.email       = ["hello@scottmiller.io"]
  s.homepage    = "http://helpy.io"
  s.summary     = "Adds an onboarding flow for new users."
  s.description = "This adds an onboarding flow for configuring a new Helpy instance."
  s.license     = "MIT."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.7"
  s.add_dependency "deface"

  s.add_development_dependency "sqlite3"
end
