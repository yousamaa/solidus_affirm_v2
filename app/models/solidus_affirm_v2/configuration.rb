# frozen_string_literal: true

module SolidusAffirmV2
  class Configuration < Spree::Preferences::Configuration

    # Allows implementing custom controller for handling the confirming
    #  and canceling callbacks from Affirm.
    # @!attribute [rw] callback_controller_name
    # @see Spree::AffirmV2::CallbackController
    # @return [String] The controller name used in the routes file.
    #   The standard controller is the 'affirm' controller
    attr_writer :callback_controller_name
    def callback_controller_name
      @callback_controller_name ||= "callback"
    end

    # Allows implementing custom callback hook for confirming and canceling
    #  callbacks from Affirm.
    # @!attribute [rw] callback_hook
    # @see SolidusAffirmV2::CallbackHook::Base
    # @return [Class] an object that conforms to the API of
    #   the standard callback hook class SolidusAffirmV2::CallbackHook::Base.
    attr_writer :callback_hook
    def callback_hook
      @callback_hook ||= SolidusAffirmV2::CallbackHook::Base
    end

    # Allows overriding the main checkout payload serializer
    # @!attribute [rw] checkout_payload_serializer
    # @see SolidusAffirmV2::CheckoutPayloadSerializer
    # @return [Class] The serializer class that will be used for serializing
    #  the +SolidusAffirmV2::CheckoutPayload+ object.
    attr_writer :checkout_payload_serializer
    def checkout_payload_serializer
      @checkout_payload_serializer ||= SolidusAffirmV2::CheckoutPayloadSerializer
    end
  end
end
