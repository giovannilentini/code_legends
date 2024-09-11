## COMANDI PER INIZIALIZZARE IL SERVER POSTGRES

    sudo apt update
    
    sudo apt install postgresql postgresql-contrib 
    
    sudo service postgresql start


Fare questo comando, inserire prima la password dell'utente linux e poi quella dell'utente "postgres", default dovrebbe essere postgres 

    sudo -u postgres psql
    
Poi proseguire con la creazione dei database 

    CREATE ROLE 'code_legends' WITH LOGIN PASSWORD 'code_legends';
    
    ALTER ROLE code_legends CREATEDB;

    CREATE DATABASE code_legends OWNER code_legends;
    
    CREATE DATABASE code_legends_development OWNER code_legends;
    
    CREATE DATABASE code_legends_test OWNER code_legends;
    
    GRANT ALL PRIVILEGES ON DATABASE code_legends TO code_legends;
    
    GRANT ALL PRIVILEGES ON DATABASE code_legends_development TO code_legends;
    
    GRANT ALL PRIVILEGES ON DATABASE code_legends_test TO code_legends;


Poi per rails 

    rails db:drop && rails db:create && rails db:migrate