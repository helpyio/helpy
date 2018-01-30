class RebuildSearchJob < ApplicationJob
  queue_as :default

  # Calls a search rebuild, used when categories are updated
  def perform
    PgSearch::Multisearch.rebuild(Doc)
  end
end
