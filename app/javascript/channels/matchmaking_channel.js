import {createConsumer} from "@rails/actioncable"


export function createMatchmakingSubscription() {
    const consumer = createConsumer()
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


