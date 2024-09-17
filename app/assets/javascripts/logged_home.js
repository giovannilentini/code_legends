function makeDraggable(element) {
    let isDragging = false;
    let offset = { x: 0, y: 0 };

    element.addEventListener('mousedown', function(e) {
        isDragging = true;
        offset.x = e.clientX - element.offsetLeft;
        offset.y = e.clientY - element.offsetTop;
        element.style.cursor = 'grabbing';
        e.preventDefault();

        function onMouseMove(e) {
            if (isDragging) {
                element.style.left = (e.clientX - offset.x) + 'px';
                element.style.top = (e.clientY - offset.y) + 'px';
            }
        }

        function onMouseUp() {
            if (isDragging) {
                isDragging = false;
                element.style.cursor = 'pointer';
                document.removeEventListener('mousemove', onMouseMove);
                document.removeEventListener('mouseup', onMouseUp);
            }
        }
        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup', onMouseUp);
    });
}



  const icons = document.querySelectorAll('[class*="-icon"], .file-icon');
  icons.forEach(icon => makeDraggable(icon));

const userElement = document.getElementById('userData');
const isGuest = userElement.getAttribute('data-guest') === 'true';
const user_id = userElement.getAttribute('data-user-id')
// Selezione degli elementi delle modali

const mailboxModal = document.getElementById('mailboxModal');
const openMailboxBtn = document.getElementById('openMailbox');
const closeMailboxBtn = document.getElementById('closeMailbox');

const requestModal = document.getElementById('requestModal');
const closeRequestBtn = document.getElementById('closeRequest');

const challengeModal = document.getElementById('challengeModal');

const challengeRequestModal = document.getElementById('challengeRequestModal');
const closeChallengeRequestBtn = document.getElementById('closeChallengeRequest');

updateDateTime();
setInterval(updateDateTime, 1000);

function openMailBoxModal() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        mailboxModal.classList.remove('hidden');

        const notificationIcon = document.getElementById("notifications");
        const notificationDot = document.querySelector(".notification-dot");

        if (notificationDot) {
            notificationDot.remove();
            notificationIcon.classList.remove('has-notifications');
        }

        return false;
    }
}

closeMailboxBtn.addEventListener('click', () => {
    mailboxModal.classList.add('hidden');
});

document.querySelectorAll('a[data-request-id]').forEach(link => {
    link.addEventListener('click', (event) => {
        event.preventDefault();
        const requestId = link.dataset.requestId;
        const senderName = document.querySelector("#request-anchor").dataset.username
        document.getElementById('requestMessage').innerText = `Hi, i'm ${senderName}, do you want to be my friend?`;

        requestModal.classList.remove('hidden');
        document.getElementById('acceptRequestForm').action = `/friend_requests/${requestId}/accept`;
        document.getElementById('rejectRequestForm').action = `/friend_requests/${requestId}/reject`;
    });
});

closeRequestBtn.addEventListener('click', () => {
    requestModal.classList.add('hidden');
});

document.querySelectorAll('.challenge-request').forEach(link => {
    link.addEventListener('click', (event) => {
        event.preventDefault();
        const challengeId = link.dataset.challengeId;
        const senderName = document.querySelector("#challenge-request-anchor").dataset.username
        document.getElementById('challengeMessage').innerText = `You have new challenge request from ${senderName}.`;

        challengeRequestModal.classList.remove('hidden');
        document.getElementById('acceptChallengeForm').action = `/challenge_requests/${challengeId}/accept`;
        document.getElementById('rejectChallengeForm').action = `/challenge_requests/${challengeId}/reject`;
    });
});

closeChallengeRequestBtn.addEventListener('click', () => {
    challengeRequestModal.classList.add('hidden');
});

function openChallengeModal() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        challengeModal.classList.remove('hidden');
        return false;
    }
}

function openGuestModal() {
    const errorSound = document.getElementById('errorSound');
    errorSound.play();

    document.getElementById('guestModal').classList.remove('hidden');
}

function closeGuestModal() {
    document.getElementById('guestModal').classList.add('hidden');
}

function closeChallengeModal() {
    challengeModal.classList.add('hidden');
}

function openSearchModal() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        document.getElementById("searchFriendsModal").classList.remove("hidden");
        return false;
    }
}

function closeModal() {
    document.getElementById("searchFriendsModal").classList.add("hidden");
}

function gotoSpaceInvaders() {
    window.location.href = '/space_invaders';
}

function gotoAdminProfile() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        window.location.href = `/admins/${user_id}`;
        return false;
    }
}

function gotoNewChallenge() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        window.location.href = '/challenge_proposals/new';
        return false;
    }
}

function gotoProfile() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        window.location.href = `/users/${user_id}`;
        return false;
    }
}

function gotoLeaderboard() {
    window.location.href = '/leaderboard';
}

function toggleTerminal() {
    const terminal = document.getElementById('terminal-window');
    terminal.classList.toggle('hidden');
}

function gotoPlayNow() {
    window.location.href = '/play_now';
}

function updateDateTime() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const current_hour = document.getElementById('current-time')
    if(current_hour)
        current_hour.textContent = `${hours}:${minutes}`;

    const day = now.getDate().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const year = now.getFullYear();
    const current_date = document.getElementById('current-date')
        if(current_date)
            current_date.textContent = `${day}/${month}/${year}`;

}