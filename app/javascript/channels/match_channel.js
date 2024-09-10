import {createConsumer} from "@rails/actioncable"
import consumer from "./consumer";
import { displayPopup } from "../popup";

export function createMatchSubscription(matchId){
  consumer.subscriptions.create(
      { channel: "MatchChannel", match_id: matchId },
      {
        connected() {
          console.log("Connected to the match channel");
        },

        disconnected() {
          console.log("Disconnected from the match channel");
        },

        received(data) {
          console.log("Match Channel Data:", data);
            if (data.status === "timeout") {
                displayPopup("Draw", data.message);
            }
        },
      }
  );

}

