module Tourmaline
  class Client
    # Use this method to send invoices.
    # On success, the sent `Message` is returned.
    def send_invoice(
      chat,
      title,
      description,
      payload,
      provider_token,
      start_parameter,
      currency,
      prices,
      provider_data = nil,
      photo_url = nil,
      photo_size = nil,
      photo_width = nil,
      photo_height = nil,
      need_name = nil,
      need_shipping_address = nil,
      send_phone_number_to_provider = nil,
      send_email_to_provider = nil,
      is_flexible = nil,
      disable_notification = nil,
      reply_to_message = nil,
      reply_markup = nil
    )
      chat_id = chat.is_a?(Int) ? chat : chat.id
      reply_to_message_id = reply_to_message.is_a?(Int) ? reply_to_message : reply_to_message.id

      response = request("sendInvoice", {
        chat_id:                       chat_id,
        title:                         title,
        description:                   description,
        payload:                       payload,
        provider_token:                provider_token,
        start_parameter:               start_parameter,
        currency:                      currency,
        prices:                        prices.to_json,
        provider_data:                 provider_data,
        photo_url:                     photo_url,
        photo_size:                    photo_size,
        photo_width:                   photo_width,
        photo_height:                  photo_height,
        need_name:                     need_name,
        need_shipping_address:         need_shipping_address,
        send_phone_number_to_provider: send_phone_number_to_provider,
        send_email_to_provider:        send_email_to_provider,
        is_flexible:                   is_flexible,
        disable_notification:          disable_notification,
        reply_to_message_id:           reply_to_message_id,
        reply_markup:                  reply_markup,
      })

      Message.from_json(response)
    end

    # If you sent an invoice requesting a shipping address and the parameter is_flexible
    # was specified, the Client API will send a `Update` with a shipping_query field to
    # the bot. Use this method to reply to shipping queries.
    # On success, `true` is returned.
    def answer_shipping_query(
      shipping_query_id,
      ok,
      shipping_options = nil,
      error_message = nil
    )
      response = request("answerShippingQuery", {
        shipping_query_id: shipping_query_id,
        ok:                ok,
        shipping_options:  shipping_options,
        error_message:     error_message,
      })

      Bool.from_json(response)
    end

    # Once the user has confirmed their payment and shipping details, the Client API sends
    # the final confirmation in the form of a `Update` with the field pre_checkout_query.
    # Use this method to respond to such pre-checkout queries.
    # On success, `true` is returned.
    #
    # > Note: The Client API must receive an answer within 10 seconds after the
    # > pre-checkout query was sent.
    def answer_pre_checkout_query(
      pre_checkout_query_id,
      ok,
      error_message = nil
    )
      response = request("answerPreCheckoutQuery", {
        pre_checkout_query_id: pre_checkout_query_id,
        ok:                    ok,
        error_message:         error_message,
      })

      Bool.from_json(response)
    end

    # Convenience method to create and `Array` of `LabledPrice` from an `Array`
    # of `NamedTuple(label: String, amount: Int32)`.
    def labeled_prices(lp : Array(NamedTuple(label: String, amount: Int32)))
      lp.reduce([] of Tourmaline::LabeledPrice) { |acc, i|
        acc << Tourmaline::LabeledPrice.new(label: i[:label], amount: i[:amount])
      }
    end

    # Convenience method to create an `Array` of `ShippingOption` from a
    # `NamedTuple(id: String, title: String, prices: Array(LabeledPrice))`.
    def shipping_options(options : Array(NamedTuple(id: String, title: String, prices: Array(LabeledPrice))))
      lp.reduce([] of Tourmaline::ShippingOption) { |acc, i|
        acc << Tourmaline::ShippingOption.new(id: i[:id], title: i[:title], prices: i[:prices])
      }
    end
  end
end
