module Griddler
  module Imap
    class Adapter
    end
  end
end

Griddler.adapter_registry.register(:imap, Griddler::Imap::Adapter)
