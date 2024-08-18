import consumer from "./consumer"

const languageSelect = document.getElementById('language-select')

if (languageSelect) {
  const language = languageSelect.value
  const channel = consumer.subscriptions.create(
    { channel: "MatchmakingChannel", language: language },
    {
      received(data) {
        if (data.type === 'MATCH_FOUND') {
          window.location.href = data.challenge_url
        }
      }
    }
  )
}
