import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener("turbo:load", () => {
    let language = document.querySelector("#language").value
    if(language) {
        consumer.subscriptions.create({channel: "MatchmakingChannel", language: language}, {
            connected() {
                // Called when the subscription is ready for use on the server
                console.log(`Connected to matchmaking channel for the language ${language}`)
            },

            disconnected() {
                // Called when the subscription has been terminated by the server
                console.log("Disconnected from matchmaking channel")
            },

            received(data) {
                // Called when there's data broadcasted to this channel
                window.location.href = `/challenges/${data.challenge_id}`;
                // Handle the incoming data here
            },

        })
    }
});
