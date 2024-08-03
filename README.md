
# Versione RUBY: 2.7.2

# Versione RAILS: 7.1.3.4

ultima versione, quindi aggiornare con il comando

    gem update rails

# Installazione RVM

Per scegliere la versione 2.7.2 di Ruby usiamo RVM.

Installare RVM: 

    \curl -sSL https://get.rvm.io | bash
    rvm install 2.7.2

Verificare la versione di ruby facendo 

    rvm list 

Comandi da fare per evitare errore "Error running __rvm_make -j4..."

    rvm pkg install openssl 
    rvm install 2.7.2 --with-openssl-dir=$rvm_path/usr 

# Avviare applicazione
Andare nella cartella principale e scrivere 

    rails server 

Poi nel browser andare a localhost:3000 

# GitHub

Lavoriamo nel branch "dev" e poi, dopo tutti i test, facciamo il merge nel main
Quindi 

    git clone https://www.github.com/giovannilentini/code_legends

    git checkout dev 

Ogni volta che vogliamo fare qualcosa di nuovo assicuriamoci di avere tutte le modifiche recenti fatte con

    git pull 


# Modello ER
Link Figma

    https://www.figma.com/board/ShrCXmS3xafvPNAF6OsWus/ERMODEL?node-id=0-1&t=8BQps2GMOgilnbdi-0


# Schema UML
Link Figma 
    
    da fare

# Bozze di Sketches
Link Figma

    https://www.figma.com/board/Ibhwg8h6p1ZcFJkNkbWFxu/Sketches?node-id=0-1&t=kUfKxbrFfEDBe3Q0-1
    
