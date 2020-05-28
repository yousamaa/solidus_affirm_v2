# frozen_string_literal: true

require 'spec_helper'
require 'affirm'

RSpec.describe SolidusAffirmV2::CallbackHook::Base do
  let(:order) { create(:order_with_totals, state: order_state) }
  let(:order_state) { "payment" }
  let(:payment_method) { create(:affirm_v2_payment_method) }
  let(:affirm_payment_source) { create(:affirm_v2_transaction) }

  let(:checkout_token) { "TKLKJ71GOP9YSASU" }
  let(:transaction_id) { "N330-Z6D4" }

  let(:payment) do
    create(
      :payment,
      response_code: nil,
      order: order,
      source: affirm_payment_source,
      payment_method: payment_method
    )
  end

  subject { SolidusAffirmV2::CallbackHook::Base.new }

  describe "authorize!" do
    context "with authorized affirm transaction" do
      let!(:affirm_transaction_response) { Affirm::Struct::Transaction.new({ id: transaction_id, provider_id: 1, amount: 42499, status: "authorized" }) }

      before do
        allow_any_instance_of(Affirm::Client).to receive(:authorize).with(checkout_token).and_return(affirm_transaction_response)
        allow_any_instance_of(Affirm::Client).to receive(:read_transaction).with(transaction_id).and_return(affirm_transaction_response)
      end

      it "will set the payment amount to the affirm amount" do
        expect { subject.authorize!(payment) }.to change{ payment.amount }.from(0).to(424.99)
      end

      it "will set the affirm transaction_id on the payment" do
        expect { subject.authorize!(payment) }.to change{ payment.transaction_id }.from(nil).to(transaction_id)
      end

      it "will save the affirm transaction_id on the payment source" do
        expect { subject.authorize!(payment) }.to change{ payment.source.transaction_id }.from(nil).to(transaction_id)
      end

      context "when order state is payment" do
        it "moves the order to the next state" do
          expect { subject.authorize!(payment) }.to change{ payment.order.state }.from("payment").to("confirm")
        end
      end

      context "when order state is not payment" do
        let!(:order_state) { "confirm" }

        it "doesn't raise a StateMachines::InvalidTransition exception" do
          expect { subject.authorize!(payment) }.not_to raise_error
        end
      end
    end
  end
end
