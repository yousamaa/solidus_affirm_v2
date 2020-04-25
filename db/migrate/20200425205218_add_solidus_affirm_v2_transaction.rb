# frozen_string_literal: true

class AddSolidusAffirmV2Transaction < ActiveRecord::Migration[5.1]
  def change
    create_table :solidus_affirm_v2_transactions do |t|
      t.string :transaction_id
      t.timestamps
    end
  end
end
