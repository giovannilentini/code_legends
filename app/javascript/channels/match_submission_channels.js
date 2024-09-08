import {createChatSubscription} from "./chat_channel";
import {createMatchSubscription} from "./match_channel";
import {createSubmissionSubscription} from "./submission_channel";

function subscribeToMatchAndSubmissionChannels(matchId, userId) {
    createChatSubscription(matchId)
    createMatchSubscription(matchId)
    createSubmissionSubscription(matchId, userId)
}
// Export the function to use in your erb file
export { subscribeToMatchAndSubmissionChannels };