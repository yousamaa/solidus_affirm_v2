# frozen_string_literal: true

class AddProviderToSolidusAffirmV2Transactions < ActiveRecord::Migration[5.1]
  def change
    add_column :solidus_affirm_v2_transactions, :provider, :string, default: :affirm
  end
end
