module Griddler
  module Pop3
    class Adapter
    end
  end
end

Griddler.adapter_registry.register(:imap, Griddler::Pop3::Adapter)
