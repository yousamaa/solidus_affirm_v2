# frozen_string_literal: true

FactoryBot.define do
  factory :affirm_v2_transaction, class: SolidusAffirmV2::Transaction do
    checkout_token { "TKLKJ71GOP9YSASU" }
    provider { "affirm" }
  end
end
