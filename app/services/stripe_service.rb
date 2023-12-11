class StripeService
  def create_charge(amount, currency, source)
    Stripe::Charge.create({ amount: amount, currency: currency, source: source })
  end

  def refund_charge(charge_id)
    Stripe::Refund.create({ charge: charge_id })
  end
end
