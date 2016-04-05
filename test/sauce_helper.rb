require 'sauce'

Sauce.config do |config|
  config[:username] = "helpy"
  config[:access_key] = "3f385552-7722-4daa-a3de-c8df23989ad9"
  config[:os] = "Windows"
  config[:browser] = "Chrome"
end
