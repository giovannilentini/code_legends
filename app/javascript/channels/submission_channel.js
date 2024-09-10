// Subscription to the Submission Channel
import consumer from "./consumer";
import { displayPopup } from "../popup";

export function createSubmissionSubscription(matchId, userId){
    consumer.subscriptions.create(
        { channel: "SubmissionChannel", match_id: matchId, user_id: userId },
        {
            connected() {
                console.log("Connected to the submission channel");
            },

            disconnected() {
                console.log("Disconnected from the match channel");
            },
            received(data) {
                console.log("Submissions Channel Data:", data);
                if (data.status === "winner") {
                    displayPopup("Winner", data.message);
                } else if (data.status === "loser") {
                    displayPopup("Loser", data.message);
                }
            },
        }
    );
}