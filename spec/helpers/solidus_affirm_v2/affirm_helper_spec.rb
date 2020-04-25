# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SolidusAffirmV2::AffirmHelper do
  describe "#affirm_js_setup" do
    let!(:payment_method) { create(:affirm_v2_payment_method) }

    it "returns the Affirm.js component" do
      output = helper.affirm_js_setup(
        SolidusAffirmV2::PaymentMethod.first.preferred_public_api_key,
        SolidusAffirmV2::PaymentMethod.first.preferred_javascript_url
      )
      expect(output).to include("public_api_key: \"public000\"")
      expect(output).to include("script: \"https://cdn1-sandbox.affirm.com/js/v2/affirm.js\"")
    end
  end

  describe "#affirm_payload_json" do
    let(:shipping_address) { create(:ship_address, firstname: "John's", lastname: "Do", zipcode: "52106-9133") }
    let(:order) do
      create(:order_with_line_items, ship_address: shipping_address)
    end
    let(:payment_method) { create(:affirm_v2_payment_method) }
    let(:metadata) { {} }

    it "calls the configured payload serializer" do
      expect(SolidusAffirmV2::Config.checkout_payload_serializer).to receive(:new)
      helper.affirm_payload_json(order, payment_method, metadata)
    end
  end

end
