# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations, id: :uuid do |t|
      t.boolean :accepted, default: false, index: true
      t.references :lesson, type: :uuid, index: true
      t.references :student, foreign_key: { to_table: :users }, type: :uuid, index: true
      t.references :teacher, foreign_key: { to_table: :users }, type: :uuid, index: true

      t.timestamps
    end
  end
end
