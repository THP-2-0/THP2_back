# frozen_string_literal: true

class AddCreatorToLessons < ActiveRecord::Migration[5.2]
  def change
    change_table :lessons do |t|
      t.references :creator, foreign_key: { to_table: :users }, type: :uuid, index: true
    end
  end
end
