import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
    const chatContainer = document.getElementById('chat');
    const chatForm = document.getElementById('chat-form');
    const messageInput = document.getElementById('chat-input'); // Riferimento all'input del messaggio

    if (chatContainer) {
        const matchId = document.getElementById('match-id').value;
        const userId = messageInput.dataset.userId;

        const chatChannel = consumer.subscriptions.create(
            { channel: "ChatChannel", match_id: matchId },
            {
                received(data) {
                    chatContainer.insertAdjacentHTML('beforeend', data);
                    chatContainer.scrollTop = chatContainer.scrollHeight; // Scroll to bottom
                },
                send_message(content) {
                    this.perform('send_message', { match_id: matchId, user_id: userId, content: content });
                }
            }
        );

        chatForm.addEventListener('ajax:success', (event) => {
            const [data, status, xhr] = event.detail;
            chatChannel.send_message(messageInput.value);
            messageInput.value = '';
        });

        chatForm.addEventListener('ajax:error', (event) => {
            console.error('Errore nell\'invio del messaggio:', event);
        });
    }
});
