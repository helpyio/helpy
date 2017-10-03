module SentenceCase
  extend ActiveSupport::Concern

  included do
    before_create :set_name_case
  end

  private

    def set_name_case
      if self.is_a?(Doc)
        self.title = self.title.sentence_case
      else
        self.name = self.name.sentence_case
      end
    end

end
