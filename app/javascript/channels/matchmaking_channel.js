import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener("turbo:load", () => {
    let language = document.querySelector("#language")
    if(language) {
        const selected_lang = language.value
        consumer.subscriptions.create({channel: "MatchmakingChannel", language: selected_lang}, {
            connected() {
                // Called when the subscription is ready for use on the server
                console.log(`Connected to matchmaking channel for the language ${selected_lang}`)
            },

            disconnected() {
                consumer.subscriptions.remove()
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
