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
export function initializeCodeMirror(editorElement, form, hidden_form, language, initial_newline_number){
    let editor;
    let code_template = "helo"
    let languageExtension = python()
    const initialNewLines = '\n'.repeat(initial_newline_number);
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
                    languageExtension = python();
            }
            // Creating the Editor using CodeMirror
            const state = EditorState.create({
                doc: initialCodeContent.concat(initialNewLines),
                extensions: [basicSetup, indentUnit.of("    "), languageExtension,  EditorView.lineWrapping, keymap.of([indentWithTab]), oneDark]
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
}

