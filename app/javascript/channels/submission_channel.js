// Subscription to the Submission Channel
import consumer from "./consumer";

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

function displayPopup(status, message) {
    const popup = document.createElement("div");
    // Countdown duration in seconds
    let countdown = 5;

    // Add Tailwind CSS classes and specific styles for the popup based on the status
    popup.classList.add(
        "fixed", "inset-0", "flex", "items-center", "justify-center", "z-50", "bg-gray-900", "bg-opacity-50"
    );

    const statusClass = status.toLowerCase() === "winner" ? "bg-green-500" : "bg-red-500";

    popup.innerHTML = `
    <div class="popup-content p-6 ${statusClass} text-white rounded-lg shadow-lg text-center max-w-md w-full">
      <strong class="text-xl block mb-4">${status}!</strong>
      <p class="text-lg mb-4">${message}</p>
      <p class="text-sm countdown">Redirecting to home page in 
        <span id="countdown">${countdown}</span> seconds...
      </p>
    </div>
  `;

    // Append the popup to the body
    document.body.appendChild(popup);

    // Countdown logic
    const countdownInterval = setInterval(() => {
        countdown -= 1;
        const countdownElement = document.getElementById("countdown");

        if (countdownElement) {
            countdownElement.textContent = countdown;
        }

        if (countdown <= 0) {
            clearInterval(countdownInterval);
            // Optionally remove the popup before redirecting
            popup.remove();
            window.location.href = "/"; // Redirect to home page after countdown
        }
    }, 1000);
}