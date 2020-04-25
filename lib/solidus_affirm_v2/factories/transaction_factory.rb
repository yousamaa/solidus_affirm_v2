# frozen_string_literal: true

FactoryBot.define do
  factory :affirm_v2_transaction, class: SolidusAffirmV2::Transaction do
    transaction_id { "12345678910" }
  end
end
