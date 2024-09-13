Feature: Timeout e fine della partita in pareggio

  Scenario: Il timer del match scade e la partita termina in pareggio con due utenti registrati
    Given che esistono due utenti registrati
    And che esiste una partita con timer attivo tra questi due utenti
    And la partita ha un timer che scade fra pochi secondi
    When passa il tempo e il timer scade
    Then la partita dovrebbe essere segnata come "finished"
    And non dovrebbe essere assegnato alcun vincitore

  Scenario: Un giocatore si arrende e la partita termina con una vittoria per l'altro giocatore
    Given che esistono due utenti registrati
    And che esiste una partita con timer attivo tra questi due utenti
    When un giocatore si arrende
    Then la partita dovrebbe essere segnata come "finished"
    And il giocatore che non si è arreso dovrebbe essere il vincitore

  Scenario: Un giocatore vince la partita inviando un codice corretto
    Given che esistono due utenti registrati
    Given an external API is called
    And che esiste una partita con timer attivo tra questi due utenti
    And il giocatore 1 ha inviato un codice vincente
    When il giocatore 2 invia un codice che viene valutato come perdente
    Then la partita dovrebbe essere segnata come "finished"
    And il giocatore 1 dovrebbe essere il vincitore
    And il giocatore 2 dovrebbe essere il perdente
