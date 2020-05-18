class AddCheckoutTokenToAffirmV2Transactions < ActiveRecord::Migration[5.1]
  def change
    add_column :solidus_affirm_v2_transactions, :checkout_token, :string
  end
end
