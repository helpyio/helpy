# config/initializers/callback_terminator.rb
ActiveSupport.halt_callback_chains_on_return_false = true

# So now for every callback you need to halt the transaction you need to throw(:abort) explicitly:

# class Person < ApplicationRecord
#   before_create do
#     throw(:abort) if you_need_to_halt
#   end
# end