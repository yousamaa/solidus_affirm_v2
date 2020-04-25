# frozen_string_literal: true

module SolidusAffirmV2
  class Transaction < Spree::PaymentSource
    self.table_name = "solidus_affirm_v2_transactions"
  end
end
