# frozen_string_literal: true

module SolidusAffirmV2
  class PaymentMethod < Spree::PaymentMethod
    preference :public_api_key, :string
    preference :private_api_key, :string
    preference :javascript_url, :string

    def payment_source_class
      Transaction
    end

    def source_required?
      true
    end

    def partial_name
      'affirm_v2'
    end

    def supports?(source)
      source.is_a? payment_source_class
    end

    def payment_profiles_supported?
      false
    end

    # Affirm doesn't have a purchase endpoint
    # so autocapture doesn't make sense. Especially because you have to
    # leave the store and come back to confirm your order. Stores should
    # capture affirm payments after the order transitions to complete.
    # @return false
    def auto_capture
      false
    end

    def try_void(payment)
      transaction_id = payment.response_code
      begin
        transaction = ::Affirm::Client.new.read_transaction(transaction_id)
      rescue Exception => e
        return ActiveMerchant::Billing::Response.new(false, e.message)
      end

      if transaction.status == "authorized"
        void(transaction_id, nil, {})
      else
        false
      end
    end

    protected

    def gateway_class
      Gateway
    end
  end
end
