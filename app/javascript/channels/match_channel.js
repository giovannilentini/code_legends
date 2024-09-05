import {createConsumer} from "@rails/actioncable"

const consumer = createConsumer()
function createSubscription(match_id) {
  // Create a new subscription
  return consumer.subscriptions.create({ channel: "MatchChannel", match_id: match_id }, {
    connected() {
      console.log("Connected to the match channel");
    },

    disconnected() {
      console.log("Disconnected from the match channel");
    },
    received(data) {
      if (data.action === 'redirect_to_play_now') {
        console.log("MATCH HAS ENDED");
        window.location.href = `/play_now`;
        this.disconnected()
      }
    }
  });
}

document.addEventListener('turbo:load', () => {
  // Ensure previous subscription is cleaned up
  const path = window.location.pathname;

  // Check if the path matches the `/matches/:id` pattern
  const matchPathPattern = /^\/matches\/(\d+)$/;
  const matchPathMatch = path.match(matchPathPattern);
  if (matchPathMatch) {
    // Extract the match ID from the URL
    const matchId = matchPathMatch[1];
    // Create the subscription if we have a match ID
    if (matchId) {
      createSubscription(matchId);
    }
  }
});

