import consumer from "./consumer";
export function createChallengeNotificationChannel(){
  consumer.subscriptions.create("ChallengeNotificationChannel", {
    connected() {
      console.log("Connected to the challenge notification channel channel");
    },
    disconnected() {
      console.log("Disconnected to the challenge notification channel channel");
    },
    received(data) {
      if (data.action === 'redirect_to_match') {
        window.location.href = `/matches/${data.match_id}`;
      }
    }
  });
}

