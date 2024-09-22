Feature: Timeout e fine della partita in pareggio

  Scenario: Il timer del match scade e la partita termina in pareggio
    Given che esistono due utenti registrati
    And gli utenti sono loggati
    And che esiste una partita con timer attivo tra questi due utenti
    And l'utente "player1" è nella pagina della partita
    And l'utente "player2" è nella pagina della partita
    And gli utenti aspettano la connessione con gli ActionCable
    Then un timer è presente
    When il timer scade
    And non dovrebbe essere assegnato alcun vincitore
    And la partita dovrebbe essere segnata come "finished"

  Scenario: Un giocatore si arrende e la partita termina con una vittoria per l'altro giocatore
    Given che esistono due utenti registrati
    And gli utenti sono loggati
    And che esiste una partita con timer attivo tra questi due utenti
    And l'utente "player1" è nella pagina della partita
    And l'utente "player2" è nella pagina della partita
    And gli utenti aspettano la connessione con gli ActionCable
    When l'utente "player1" si arrende
    Then la partita dovrebbe essere segnata come "finished"
    And l'utente "player2" dovrebbe essere il vincitore


  Scenario: Un giocatore manda il codice giusto e la partita termina con una vittoria per quest'ultimo
    Given che esistono due utenti registrati
    Given api esterna
    And gli utenti sono loggati
    And che esiste una partita con timer attivo tra questi due utenti
    And l'utente "player1" è nella pagina della partita
    And l'utente "player2" è nella pagina della partita
    And gli utenti aspettano la connessione con gli ActionCable
    When il "player1" manda il codice giusto
    Then la partita dovrebbe essere segnata come "finished"
    And l'utente "player1" dovrebbe essere il vincitore

  Scenario: Un giocatore manda un messaggio
    Given che esistono due utenti registrati
    And gli utenti sono loggati
    And che esiste una partita con timer attivo tra questi due utenti
    And l'utente "player1" è nella pagina della partita
    And l'utente "player2" è nella pagina della partita
    And gli utenti aspettano la connessione con gli ActionCable
    And gli utenti sono sulla sezione chat
    When il "player1" manda un messaggio
    Then il "player2" riceve il messaggio
