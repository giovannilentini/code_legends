// Ottieni i dati dell'utente dal markup HTML
const userElement = document.getElementById('userData');
const isGuest = userElement.getAttribute('data-guest') === 'true';

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

// Funzioni per gestire le modali
function openMailBoxModal() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        mailboxModal.classList.remove('hidden');
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
        const senderName = link.innerText.split(' ')[3];
        document.getElementById('requestMessage').innerText = `Ciao, sono ${senderName}, vuoi diventare mio amico?`;

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
        const senderName = link.innerText.split(' ')[3];
        document.getElementById('challengeMessage').innerText = `Hai una nuova sfida da ${senderName}. Accetti?`;

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
        window.location.href = '/admin_profile';
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
        window.location.href = '/profile';
        return false;
    }
}

function gotoLeaderboard() {
    if (isGuest) {
        openGuestModal();
        return true;
    } else {
        window.location.href = '/leaderboard';
        return false;
    }
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
    document.getElementById('current-time').textContent = `${hours}:${minutes}`;

    const day = now.getDate().toString().padStart(2, '0');
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const year = now.getFullYear();
    document.getElementById('current-date').textContent = `${day}/${month}/${year}`;
}