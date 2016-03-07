class String
  def sentence_case
    self.sub(/^(.)/) { $1.capitalize }
  end
end
