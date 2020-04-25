# frozen_string_literal: true

require "spec_helper"

RSpec.describe SolidusAffirmV2::PaymentMethod do
  subject { create(:affirm_v2_payment_method) }

  describe "gateway" do
    it "returns a SolidusAffirmV2::Gateway instance" do
      expect(subject.gateway).to be_a SolidusAffirmV2::Gateway
    end
  end

  describe "payment_source_class" do
    it "returns a SolidusAffirmV2::Transaction class" do
      expect(subject.payment_source_class).to eql SolidusAffirmV2::Transaction
    end
  end
end
