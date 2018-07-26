# frozen_string_literal: true

class LinkLessonToClassroom < ActiveRecord::Migration[5.2]
  def change
    change_table :lessons do |t|
      t.references :classroom, type: :uuid, index: true
    end
  end
end
