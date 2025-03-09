class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    ActiveSupport.halt_callback_chains_on_return_false = false
end
