// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import { EditorState } from "@codemirror/state";
import { EditorView, basicSetup } from "@codemirror/basic-setup";
import { javascript } from "@codemirror/lang-javascript";
import { python } from "@codemirror/lang-python";
import { cpp } from "@codemirror/lang-cpp";
import { java } from "@codemirror/lang-java";
import { oneDark } from "@codemirror/theme-one-dark";
// Event that gets triggered when the page loads
document.addEventListener('DOMContentLoaded', () => {
    const editorElement = document.querySelector('#code-editor');
    const languageSelector = document.querySelector('#language-selector');
    let currentLanguage = 'python3';
    let languageExtension = python();
    const initialNewLines = '\n'.repeat(50); // 9 newlines create 10 lines in total
    let code = "";
    let editor;
    if (editorElement && languageSelector) {

        // Handle the languages extensions
        const createEditor = (language)=>{
            switch (language){
                case 'python':
                    currentLanguage = 'python3';
                    languageExtension = python();
                    break;
                case 'java':
                    currentLanguage = 'java';
                    languageExtension = java();
                    break;
                case 'cpp':
                    currentLanguage = 'cpp';
                    languageExtension = cpp();
                    break;
                default:
                    currentLanguage = 'python3';
                    languageExtension = python();
            }

            // Creating the Editor using CodeMirror
            const state = EditorState.create({
                doc: 'Hello, World!'.concat(initialNewLines),
                extensions: [basicSetup, languageExtension, oneDark,
                    EditorView.updateListener.of((v) => {
                    if (v.docChanged) {
                        code = v.state.doc.toString().trimEnd()
                    }
                })]
            });
            editor = new EditorView({
                state,
                parent: editorElement
            });
            code = editor.state.doc.toString().trimEnd()
        }
        createEditor(currentLanguage);

        // Event that gets triggered when the user changes language
        // Automatically changes the game language
        languageSelector.addEventListener('change', (event) => {
            const selectedLanguage = event.target.value;
            editorElement.innerHTML = ''; // Clear the existing game
            createEditor(selectedLanguage);
        });
    }
    const form = document.getElementById('execute-form');
    const hiddenCodeInput = document.getElementById('hidden-code-input');

    form.addEventListener('submit', function(event) {
        // Get the code from the editor and set it to the hidden input field
        console.log(code)
        hiddenCodeInput.value = code
    });
});




