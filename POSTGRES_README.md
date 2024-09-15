## Commands to Initialize the PostgreSQL Server

To get your PostgreSQL server running, follow these steps. This section will guide you through installing PostgreSQL, setting up roles and databases, and initializing your Rails app's database.

### Step 1: Update Package List

First, update your system’s package list to ensure you have the latest version of the available packages.

```bash
sudo apt update
```

### Step 2: Install PostgreSQL

Install PostgreSQL and its additional modules. This will allow you to run a PostgreSQL server on your machine.

```bash
sudo apt install postgresql postgresql-contrib postgresql-devel
```

### Step 3: Start PostgreSQL Service

Once installed, start the PostgreSQL service to ensure it's running.

```bash
sudo service postgresql start
```

### Step 4: Access PostgreSQL

Log in to the PostgreSQL command-line interface (CLI) using the `postgres` user. You will need to enter your Linux user password first, followed by the password for the PostgreSQL `postgres` user (default is likely `postgres`).

```bash
sudo -u postgres psql
```

---

## Step 5: Create a Role and Databases

Inside the PostgreSQL CLI, you will now create a role and databases for your Rails application.

1. **Create a role**: Create a new PostgreSQL role named `code_legends` with login access and a password.

   ```sql
   CREATE ROLE code_legends WITH LOGIN PASSWORD 'code_legends';
   ```

2. **Grant createdb permission**: Allow this role to create databases.

   ```sql
   ALTER ROLE code_legends CREATEDB;
   ```

3. **Create the application databases**: You will need three databases for your Rails application: the default database, the development database, and the test database.

   ```sql
   CREATE DATABASE code_legends OWNER code_legends;
   CREATE DATABASE code_legends_development OWNER code_legends;
   CREATE DATABASE code_legends_test OWNER code_legends;
   ```

4. **Grant privileges**: Give the `code_legends` role full access to the three databases you just created.

   ```sql
   GRANT ALL PRIVILEGES ON DATABASE code_legends TO code_legends;
   GRANT ALL PRIVILEGES ON DATABASE code_legends_development TO code_legends;
   GRANT ALL PRIVILEGES ON DATABASE code_legends_test TO code_legends;
   ```

---

## Step 6: Initialize Rails Database

After setting up PostgreSQL, you can initialize your Rails application's database. This command will drop any existing databases, recreate them, and run all migrations.

```bash
rails db:create && rails db:migrate && rails db:seed
```

---

By following these steps, you will have a PostgreSQL server running with the necessary databases and roles for your Rails application. You can now proceed to use your app with full database support.
