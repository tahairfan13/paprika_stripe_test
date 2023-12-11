class StripeService
  def create_charge(amount, currency, source)
    Stripe::Charge.create({ amount: amount, currency: currency, source: source })
  rescue Stripe::StripeError => e
    return e.message
  rescue => e
    return e.message
  end

  def refund_charge(charge_id)
    Stripe::Refund.create({ charge: charge_id })
  rescue Stripe::StripeError => e
    return e.message
  rescue => e
    return e.message
  end
end
