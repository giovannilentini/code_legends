// app/javascript/channels/user_channel.js
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()
consumer.subscriptions.create("MatchmakingChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
        console.log("Connected to matchmaking channel")
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("Disconnected from matchmaking channel")
    },

    received(data) {
        // Called when there's data broadcasted to this channel
        window.location.href = "challenges/"+data.challenge_id;
        // Handle the incoming data here
    },

})
