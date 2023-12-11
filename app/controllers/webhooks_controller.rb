class WebhooksController < ApplicationController
  def create
    begin
      event = construct_event
      handle_event(event)
    rescue Stripe::SignatureVerificationError => e
      head :bad_request
    else
      head :ok
    end
  end

  private

  def construct_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    Stripe::Webhook.construct_event(
      payload, sig_header, Rails.application.credentials.dig(:stripe, :endpoint_secret)
    )
  end

  def handle_event(event)
    case event.type
    when 'charge.refunded'
      handle_charge_refunded(event.data.object)
    when 'charge.succeeded'
      handle_charge_succeeded(event.data.object)
    end
  end

  def handle_charge_refunded(charge)
    # Update your refund
  end

  def handle_charge_succeeded(charge)
    # Save your subscription here
  end
end
