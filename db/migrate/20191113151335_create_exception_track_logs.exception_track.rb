# This migration comes from exception_track (originally 20170217023900)
# frozen_string_literal: true

class CreateExceptionTrackLogs < ActiveRecord::Migration
  def change
    create_table :exception_tracks do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
