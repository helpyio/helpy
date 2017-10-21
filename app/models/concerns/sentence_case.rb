module SentenceCase
  extend ActiveSupport::Concern

  included do
    before_create :set_name_case
  end

  private

  def set_name_case
    if is_a?(Doc)
      self.title = title.sentence_case
    else
      self.name = name.sentence_case
    end
  end
end
