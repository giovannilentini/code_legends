# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@codemirror/basic-setup", to: "@codemirror--basic-setup.js" # @0.20.0
pin "@codemirror/lang-javascript", to: "@codemirror--lang-javascript.js" # @6.2.2
pin "@codemirror/state", to: "@codemirror--state.js" # @6.4.1
pin "@codemirror/theme-one-dark", to: "@codemirror--theme-one-dark.js" # @6.1.2
pin "@codemirror/view", to: "@codemirror--view.js" # @6.33.0
pin "codemirror" # @6.0.1
pin "@codemirror/autocomplete", to: "@codemirror--autocomplete.js" # @6.18.0
pin "@codemirror/commands", to: "@codemirror--commands.js" # @6.6.1
pin "@codemirror/language", to: "@codemirror--language.js" # @6.10.2
pin "@codemirror/lint", to: "@codemirror--lint.js" # @6.8.1
pin "@codemirror/search", to: "@codemirror--search.js" # @6.5.6
pin "@lezer/common", to: "@lezer--common.js" # @1.2.1
pin "@lezer/highlight", to: "@lezer--highlight.js" # @1.2.1
pin "@lezer/javascript", to: "@lezer--javascript.js" # @1.4.17
pin "@lezer/lr", to: "@lezer--lr.js" # @1.4.2
pin "crelt" # @1.0.6
pin "style-mod" # @4.1.2
pin "w3c-keyname" # @2.2.8
pin "@codemirror/lang-python", to: "@codemirror--lang-python.js" # @6.1.6
pin "@lezer/python", to: "@lezer--python.js" # @1.1.14
pin "@codemirror/lang-java", to: "@codemirror--lang-java.js" # @6.0.1
pin "@lezer/java", to: "@lezer--java.js" # @1.1.2
pin "@codemirror/lang-cpp", to: "@codemirror--lang-cpp.js" # @6.0.2
pin "@lezer/cpp", to: "@lezer--cpp.js" # @1.1.2
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin "codemirror_setup", to: "codemirror_setup.js"
pin "code_generation", to: "code_generation.js"
pin "match_subscription", to: "channels/match_submission_channels.js"