
# Versione RUBY: 2.7.2
# Versione RAILS: 7.1.3.4
ultima versione, quindi aggiornare con il comando

    gem update rails

# Installazione RVM
Per scegliere la versione 2.7.2 di Ruby usiamo RVM.

Installare RVM: 

    \curl -sSL https://get.rvm.io | bash

Comandi da fare per evitare errore "Error running __rvm_make -j4..."

    rvm pkg install openssl <br>
    rvm install 2.7.2 --with-openssl-dir=$rvm_path/usr <br>

    

# Avviare applicazione
Andare nella cartella principale e scrivere 

    rails server <br>

Poi nel browser andare a localhost:3000 