# spec/services/stripe_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe StripeService, type: :service do
  let(:stripe_service) { StripeService.new }
  let(:success_response)  {{ charge_id: 'xyz' }}
  let(:amount)  { 1000 }
  let(:currency)  { 'usd' }

  describe '#create_charge' do
    it 'creates a charge successfully' do
      # Stub the Stripe::Charge.create method to simulate a successful charge creation
      allow(Stripe::Charge).to receive(:create).and_return(success_response)
      expect(stripe_service.create_charge(amount, currency, 'valid_token')).to eq(success_response)
    end

    it 'handles errors when creating a charge' do
      # Stub the Stripe::Charge.create method to simulate an error during charge creation
      allow(Stripe::Charge).to receive(:create).and_raise(Stripe::CardError.new('Invalid card', nil))
      expect(stripe_service.create_charge(amount, currency, 'invalid_token')).to eq('Invalid card')
    end
  end

  describe '#refund_charge' do
    it 'refunds a charge successfully' do
      # Stub the Stripe::Refund.create method to simulate a successful refund
      allow(Stripe::Refund).to receive(:create).and_return(success_response)
      expect(stripe_service.refund_charge('charge_id')).to eq(success_response)
    end

    it 'handles errors when refunding a charge' do
      # Stub the Stripe::Refund.create method to simulate an error during refund
      allow(Stripe::Refund).to receive(:create).and_raise(Stripe::InvalidRequestError.new('Charge not found', nil))
      result = stripe_service.refund_charge('invalid_charge_id')
      expect(result).to eq('Charge not found')
    end
  end
end
