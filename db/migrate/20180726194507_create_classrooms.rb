# frozen_string_literal: true

class CreateClassrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :classrooms, id: :uuid do |t|
      t.string :title, null: false, limit: 50
      t.text :description, limit: 300
      t.references :creator, foreign_key: { to_table: :users }, type: :uuid, index: true

      t.timestamps
    end
  end
end
