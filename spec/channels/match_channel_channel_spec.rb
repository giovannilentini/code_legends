require 'rails_helper'

RSpec.describe MatchChannel, type: :channel do
  let(:user) { User.create(username: 'TestUser', email: 'test@example.com', password: 'password123') }
  let(:match_id) { 1 }

  before do
    # Simulate a subscription with a manually created user
    stub_connection current_user: user
  end

  it 'successfully subscribes to a match stream' do
    # Simulate subscribing to the MatchChannel with the match_id parameter
    subscribe(match_id: match_id)

    # Ensure the subscription was confirmed
    expect(subscription).to be_confirmed

    # Check if the correct stream is subscribed to
    expect(subscription).to have_stream_from("match_#{match_id}")
  end
end
