import consumer from "./consumer";


export function createChatSubscription(match_id){
    const chatContainer = document.getElementById('chat-container');
    const chatForm = document.getElementById('chat-form');
    const messageInput = document.getElementById('chat-input');
// Function to scroll to the bottom of the chat container
    function scrollToBottom(element) {
        element.scrollTop = element.scrollHeight;
    }

// Ensure chat is scrolled to the bottom on initial load
    if(chatContainer){
        scrollToBottom(chatContainer);
    }

    const chatChannel = consumer.subscriptions.create(
        { channel: "ChatChannel", match_id: match_id },
        {
            connected() {
                console.log("Connected to the chat channel");
            },

            disconnected() {
                console.log("Disconnected from the chat channel");
            },

            received(data) {
                chatContainer.insertAdjacentHTML('beforeend', data);
                scrollToBottom(chatContainer);  // Ensure chat scrolls to the bottom
                messageInput.value = ''; // Clear the input field after sending
            },
            send_message(content) {
                this.perform('send_message', { match_id: match_id, content: content });

            }
        }
    );

    chatForm.addEventListener('ajax:success', (event) => {
        const [data, status, xhr] = event.detail;
        chatChannel.send_message(messageInput.value);
        // Refocus the input field for user convenience
        messageInput.focus();
    });

    chatForm.addEventListener('ajax:error', (event) => {
        console.error('Error sending message:', event);
    });

}

