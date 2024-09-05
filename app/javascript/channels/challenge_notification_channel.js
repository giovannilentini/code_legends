import consumer from "./consumer";

consumer.subscriptions.create("ChallengeNotificationChannel", {
  received(data) {
    alert(data.message); // Mostra il messaggio all'utente
    window.location.href = `/matches/${data.match_id}`; // Reindirizza alla pagina del match
  }
});
