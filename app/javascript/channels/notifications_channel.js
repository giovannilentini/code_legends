// app/javascript/channels/notifications_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  received(data) {
    if (data.has_notifications) {
      // Aggiungi il pallino rosso
      const notificationIcon = document.getElementById("notifications");
      if (notificationIcon && !notificationIcon.classList.contains('has-notifications')) {
        notificationIcon.insertAdjacentHTML('beforeend', '<span class="notification-dot"></span>');
        notificationIcon.classList.add('has-notifications');
      }
    }
  }
});
