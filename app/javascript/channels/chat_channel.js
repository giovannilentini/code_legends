import consumer from "./consumer";

document.addEventListener("turbo:load", () => {
    const chatContainer = document.getElementById('chat');
    const chatForm = document.getElementById('chat-form');
    const messageInput = document.getElementById('chat-input');

    if (chatContainer) {
        const matchId = document.getElementById('match-id').value;

        const chatChannel = consumer.subscriptions.create(
            { channel: "ChatChannel", match_id: matchId },
            {
                received(data) {
                    chatContainer.insertAdjacentHTML('beforeend', data);
                    scrollToBottom(chatContainer);  // Ensure chat scrolls to the bottom
                },
                send_message(content) {
                    this.perform('send_message', { match_id: matchId, content: content });
                }
            }
        );

        chatForm.addEventListener('ajax:success', (event) => {
            const [data, status, xhr] = event.detail;
            chatChannel.send_message(messageInput.value);

            // Clear the input field after sending
            messageInput.value = '';

            // Refocus the input field for user convenience
            messageInput.focus();
        });

        chatForm.addEventListener('ajax:error', (event) => {
            console.error('Error sending message:', event);
        });
    }

    // Function to scroll to the bottom of the chat container
    function scrollToBottom(element) {
        element.scrollTop = element.scrollHeight;
    }

    // Ensure chat is scrolled to the bottom on initial load
    scrollToBottom(chatContainer);
});
