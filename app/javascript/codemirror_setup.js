import { EditorState } from "@codemirror/state";
import { basicSetup} from "@codemirror/basic-setup";
import {indentWithTab} from "@codemirror/commands"
import {EditorView, keymap} from "@codemirror/view"
import {indentUnit} from "@codemirror/language"
import { python } from "@codemirror/lang-python";
import { cpp } from "@codemirror/lang-cpp";
import { java } from "@codemirror/lang-java";
import { oneDark } from "@codemirror/theme-one-dark";
import {create_python_template, create_java_template, create_cpp_template} from "./code_templates";
// Event that gets triggered when the page loads
document.addEventListener('DOMContentLoaded', () => {
    const editorElement = document.querySelector('#code-editor');
    let languageExtension = python();
    const initialNewLines = '\n'.repeat(50);
    let editor;

    if (editorElement) {
        // Handle the languages extensions
        const createEditor = (language)=>{
            let initialCodeContent=""
            switch (language){
                case 'python3':
                    initialCodeContent = create_python_template(code_template)
                    languageExtension = python();
                    break;
                case 'java':
                    initialCodeContent = create_java_template(code_template)
                    languageExtension = java();
                    break;
                case 'cpp':
                    initialCodeContent = create_cpp_template(code_template)
                    languageExtension = cpp();
                    break;
                default:
                    currentLanguage = 'python3';
                    languageExtension = python();
            }
            // Creating the Editor using CodeMirror
            const state = EditorState.create({
                doc: initialCodeContent.concat(initialNewLines),
                extensions: [basicSetup, indentUnit.of("    "), languageExtension,  keymap.of([indentWithTab]), oneDark]
            });
            editor = new EditorView({
                state,
                parent: editorElement
            });
            window.editor = editor;
        }

        createEditor(currentLanguage);
    }
    const form = document.getElementById('execute-form');
    const hiddenCodeInput = document.getElementById('hidden-code-input');
    if(form){
        form.addEventListener('submit', function(event) {
            // Get the code from the editor and set it to the hidden input field
            hiddenCodeInput.value = editor.state.doc.toString().trimEnd()
        });
    }

});
