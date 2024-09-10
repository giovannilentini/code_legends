export function displayPopup(status, message) {
    const popup = document.createElement("div");
    // Countdown duration in seconds
    let countdown = 5;

    // Add Tailwind CSS classes and specific styles for the popup based on the status
    popup.classList.add(
        "fixed", "inset-0", "flex", "items-center", "justify-center", "z-50", "bg-gray-900", "bg-opacity-50"
    );

    // Determina lo stile della finestra modale in base allo stato
    const statusClass = status.toLowerCase() === "winner"
        ? "bg-green-500"
        : status.toLowerCase() === "loser"
            ? "bg-red-500"
            : "bg-gray-500"; // Usa un colore grigio per il pareggio

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
