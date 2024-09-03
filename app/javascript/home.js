document.addEventListener('DOMContentLoaded', function() {
    var fileIcon = document.getElementById('file-icon');
    var terminal = document.getElementById('terminal-window');
    var utenteElement = document.getElementById('utente');

    var offset = { x: 0, y: 0 };
    var isDragging = false;

    fileIcon.addEventListener('mousedown', function(e) {
        isDragging = true;
        offset.x = e.clientX - fileIcon.offsetLeft;
        offset.y = e.clientY - fileIcon.offsetTop;
        fileIcon.style.cursor = 'grabbing';
        e.preventDefault();
    });

    document.addEventListener('mousemove', function(e) {
        if (isDragging) {
            fileIcon.style.left = (e.clientX - offset.x) + 'px';
            fileIcon.style.top = (e.clientY - offset.y) + 'px';
        }
    });

    document.addEventListener('mouseup', function() {
        if (isDragging) {
            isDragging = false;
            fileIcon.style.cursor = 'pointer';
        }
    });

    fileIcon.addEventListener('dblclick', function() {
        openTerminal();
    });

    function openTerminal() {
        terminal.classList.remove('hidden');
        fileIcon.classList.add('hidden');
        anime({
            targets: '#terminal-window',
            translateY: ['100%', '0%'],
            opacity: [0, 1],
            easing: 'easeOutCubic',
            duration: 400
        });
        startTypedEffect();
    }

    function startTypedEffect() {
        var prompts = [
            { id: 'prompt1', strings: ['Welcome to the ultimate coding battleground!'], typeSpeed: 5 },
            { id: 'prompt2', strings: ['Where programmers go head-to-head in epic code challenges.'], typeSpeed: 5 },
            { id: 'prompt3', strings: ['Select your opponent, unleash your best solutions, and claim your coding supremacy!'], typeSpeed: 5 },
            { id: 'prompt4', strings: ['Who will emerge victorious in this thrilling test of skills?'], typeSpeed: 5 },
            { id: 'prompt5', strings: ['--------------------------------------------------------------------------'], typeSpeed: 1 },
            { id: 'prompt6', strings: ["Let's get started! Do you want to play as a member or do you prefer to continue as a guest?"], typeSpeed: 5 },
            { id: 'prompt7', strings: ['Type "Member" or "Guest" and press Enter: '], typeSpeed: 5 }
        ];

        function initTyped(promptId, strings, typeSpeed, onComplete) {
            new Typed(`#${promptId}`, {
                strings: strings,
                typeSpeed: typeSpeed,
                loop: false,
                showCursor: false,
                contentType: 'text',
                onComplete: function(self) {
                    if (onComplete) {
                        setTimeout(onComplete, 200);
                    }
                }
            });
        }

        function startPrompts(index) {
            if (index < prompts.length) {
                var prompt = prompts[index];
                initTyped(prompt.id, prompt.strings, prompt.typeSpeed, function() {
                    startPrompts(index + 1);
                });
            } else {
                enableUserInput();
            }
        }

        startPrompts(0);
    }

    function enableUserInput() {
        utenteElement.classList.remove('hidden');
        utenteElement.innerHTML = '<span class="utente">Guest</span>:$ ';
        document.addEventListener('keydown', handleUserInput);
    }

    function handleUserInput(e) {
        if (e.key === 'Enter') {
            var input = utenteElement.innerHTML.split('<span class="utente">Guest</span>:$ ').pop().trim().toLowerCase();
            var response = '';
            if (input === 'member' || input === 'Member') {
                response = '<br><span class="utente">Redirecting to login screen...</span><br>';
                setTimeout(function() {
                    window.location.href = '/auth/auth0';
                }, 2000);
            } else if (input === 'guest' || input === 'Guest') {
                response = '<br>Continuing as Guest...<br>';
            } else {
                response = '<br><span class="error">Invalid input. Please type "Member" or "Guest".</span><br>';
                utenteElement.innerHTML += response;
                utenteElement.innerHTML += '<span class="utente">Guest</span>:$ ';
                return;
            }
            utenteElement.innerHTML += response;
            utenteElement.innerHTML += '<span class="utente">Guest</span>:$ ';
            document.removeEventListener('keydown', handleUserInput);
        } else if (e.key === 'Backspace') {
            var content = utenteElement.innerHTML.split('<span class="utente">Guest</span>:$ ').pop();
            content = content.slice(0, -1);
            utenteElement.innerHTML = '<span class="utente">Guest </span>:$ ' + content;
        } else if (e.key.length === 1) {
            utenteElement.innerHTML += e.key;
        }
    }
});
