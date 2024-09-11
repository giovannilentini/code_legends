import consumer from "./consumer";

export function createChallengeNotificationChannel(){
  consumer.subscriptions.create("ChallengeNotificationChannel", {
    connected() {
      console.log("Connected to the challenge notification channel channel");
    },
    received(data) {
      window.location.href = `/matches/${data.match_id}`; // Reindirizza alla pagina del match
    }
  });
}

