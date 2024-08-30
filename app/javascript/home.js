document.addEventListener('DOMContentLoaded', function() {
    var fileIcon = document.getElementById('file-icon');
    var terminal = document.getElementById('terminal-window');

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
        var options = {
            typeSpeed: 30,
            loop: false,
            showCursor: false,
            contentType: 'text' 
        };

        var prompts = [
            {
                id: 'prompt1',
                strings: ['Welcome to the ultimate coding battleground!']
            },
            {
                id: 'prompt2',
                strings: ['Where programmers go head-to-head in epic code challenges.']
            },
            {
                id: 'prompt3',
                strings: ['Select your opponent, unleash your best solutions, and claim your coding supremacy!']
            },
            {
                id: 'prompt4',
                strings: ['Who will emerge victorious in this thrilling test of skills?']
            },
            {
                id: 'prompt5',
                strings: ['--------------------------------------------------------------------------']
            }
        ];

        function initTyped(promptId, strings, onComplete) {
            new Typed(`#${promptId}`, {
                ...options,
                strings: strings,
                onComplete: function(self) {
                    if (onComplete) {
                        setTimeout(onComplete, 1000);
                    }
                }
            });
        }

        function startPrompts(index) {
            if (index < prompts.length) {
                var prompt = prompts[index];
                initTyped(prompt.id, prompt.strings, function() {
                    startPrompts(index + 1);
                });
            }
        }

        startPrompts(0);
    } 
}); 
