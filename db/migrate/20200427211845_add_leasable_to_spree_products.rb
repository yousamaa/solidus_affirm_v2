# frozen_string_literal: true

class AddLeasableToSpreeProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_products, :leasable, :boolean, default: false
  end
end
