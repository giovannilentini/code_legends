import { EditorState } from "@codemirror/state";
import { basicSetup } from "@codemirror/basic-setup";
import { indentWithTab } from "@codemirror/commands";
import { EditorView, keymap } from "@codemirror/view";
import { indentUnit } from "@codemirror/language";
import { python } from "@codemirror/lang-python";
import { javascript } from "@codemirror/lang-javascript";
import { java } from "@codemirror/lang-java";
import { oneDark } from "@codemirror/theme-one-dark";
import { githubLight } from '@fsegurai/codemirror-theme-github-light';

// Event that gets triggered when the page loads
export function initializeCodeMirror(editorElement, form, hidden_form, code_template, language, initial_newline_number, current_theme){

    const newTheme = current_theme === "dark" ? oneDark : githubLight;
    let editor;
    let languageExtension = python()
    const initialNewLines = '\n'.repeat(initial_newline_number);
    if (editorElement) {
        // Handle the languages extensions
        const createEditor = (language)=>{
            let initialCodeContent
            if(code_template!==""){
                initialCodeContent = code_template
            }else{
                initialCodeContent = "Hello, world!"
            }
            switch (language){
                case 'python3':
                    languageExtension = python();
                    break;
                case 'java':
                    languageExtension = java();
                    break;
                case 'javascript':
                    languageExtension = javascript();
                    break;
                default:
                    languageExtension = python();
            }
            // Creating the Editor using CodeMirror
            const state = EditorState.create({
                doc: initialCodeContent.concat(initialNewLines),
                extensions: [basicSetup, indentUnit.of("    "), languageExtension,  EditorView.lineWrapping, keymap.of([indentWithTab]), newTheme]
            });
            editor = new EditorView({
                state,
                parent: editorElement
            });
        }
        createEditor(language);
    }
    if(form){
        form.addEventListener('submit', function(event) {
            // Get the code from the editor and set it to the hidden input field
            hidden_form.value = editor.state.doc.toString().trimEnd()
        });
    }
    return editor
}

export function changeTheme(editor, current_theme) {
    const newTheme = current_theme === "dark" ? githubLight : oneDark; // Decide which theme to use

    // Create a new state with the new theme
    const newState = EditorState.create({
        doc: editor.state.doc, // Preserve the document
        extensions: [
            basicSetup,
            indentUnit.of("    "),
            editor.state.facet(EditorState.language) || python(), // Preserve the language extension
            EditorView.lineWrapping,
            keymap.of([indentWithTab]),
            newTheme // Apply the new theme
        ]
    });

    editor.setState(newState); // Set the new state to apply the new theme
}