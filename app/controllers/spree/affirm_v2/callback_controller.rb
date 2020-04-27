# frozen_string_literal: true

module Spree
  module AffirmV2
    class CallbackController < Spree::StoreController
      protect_from_forgery except: [:confirm]

      def confirm
        checkout_token = affirm_params[:checkout_token]
        order = Spree::Order.find(affirm_params[:order_id])

        if !checkout_token
          return redirect_to checkout_state_path(order.state), notice: "Invalid order confirmation data passed in"
        end

        if order.complete?
          return redirect_to spree.order_path(order), notice: "Order is already in complete state"
        end


        affirm_transaction = SolidusAffirmV2::PaymentMethod.active.first.gateway.get_transaction(checkout_token)
        provider = SolidusAffirmV2::Transaction::PROVIDERS[affirm_transaction.provider_id - 1]
        affirm_source_transaction = SolidusAffirmV2::Transaction.new(transaction_id: checkout_token, provider: provider)

        affirm_source_transaction.transaction do
          if affirm_source_transaction.save!
            payment = order.payments.create!({
              payment_method_id: affirm_params[:payment_method_id],
              source: affirm_source_transaction
            })
            hook = SolidusAffirmV2::Config.callback_hook.new
            hook.authorize!(payment)
            hook.remove_tax!(order) if provider == "katapult"
            redirect_to hook.after_authorize_url(order)
          end
        end
      end

      def cancel
        order = Spree::Order.find(affirm_params[:order_id])
        hook = SolidusAffirmV2::Config.callback_hook.new
        redirect_to hook.after_cancel_url(order)
      end

      private

      def affirm_params
        params.permit(:checkout_token, :payment_method_id, :order_id)
      end
    end
  end
end
