import {createConsumer} from "@rails/actioncable"

const consumer = createConsumer()
function createSubscription() {
    // Create a new subscription
    return consumer.subscriptions.create("MatchmakingChannel", {
        connected() {
            console.log("Connected to matchmaking channel");
        },

        disconnected() {
            console.log("Disconnected from matchmaking channel");
        },
        received(data) {
            if (data.action === 'redirect_to_match') {
                window.location.href = `/matches/${data.match_id}`;
            }
        }
    });
}

document.addEventListener('turbo:load', () => {
    // Ensure previous subscription is cleaned up
    const pathname = window.location.pathname;
    if(pathname==="/play_now"){
        createSubscription()
    }
});

