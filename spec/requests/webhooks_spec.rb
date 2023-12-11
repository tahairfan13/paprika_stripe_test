# spec/requests/webhooks_spec.rb
require 'rails_helper'
require 'ostruct'

RSpec.describe 'Webhooks', type: :request do
  describe 'POST /webhooks' do
    let(:endpoint_secret) { Rails.application.credentials.dig(:stripe, :endpoint_secret) }
    let(:timestamp) { Time.now.to_i }
    let(:payload) { '{"type":"charge.succeeded","data":{"object":{}},"created":' + timestamp.to_s + '}' }

    context 'with valid payload and signature' do
      it 'responds with 200 OK' do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(OpenStruct.new({type: 'charge.succeed'}))
        post '/webhooks', params: {payload: payload}, headers: { 'HTTP_STRIPE_SIGNATURE' => 'valid' }

        expect(response).to have_http_status(:ok)
      end

      it 'calls the handle_event method' do
        allow(Stripe::Webhook).to receive(:construct_event).and_return(OpenStruct.new({type: 'charge.succeed'}))
        expect_any_instance_of(WebhooksController).to receive(:handle_event)

        post '/webhooks', params: {payload: payload}, headers: { 'HTTP_STRIPE_SIGNATURE' => 'valid' }
      end
    end

    context 'with invalid request' do
      it 'responds with 400 Bad Request' do
        post '/webhooks', params: payload, headers: { 'HTTP_STRIPE_SIGNATURE' => 'invalid_signature' }

        expect(response).to have_http_status(:bad_request)
      end

      it 'does not call the handle_event method' do
        expect_any_instance_of(WebhooksController).not_to receive(:handle_event)

        post '/webhooks', params: payload, headers: { 'HTTP_STRIPE_SIGNATURE' => 'invalid_signature' }
      end
    end
  end
end
