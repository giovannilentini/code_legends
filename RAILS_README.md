# Ruby Version: 3.3.0

# Rails Version: 7.1.3.4

This project requires the latest version of Rails. Make sure to update Rails by running the following command:

```bash
gem update rails
```

---

## RVM Installation

To manage the Ruby version 3.3.0, we use **RVM (Ruby Version Manager)**. Follow the steps below to install RVM and set up Ruby.

### Step 1: Install RVM

Run the following command to install RVM:

```bash
\curl -sSL https://get.rvm.io | bash
```

Once RVM is installed, you can install Ruby version 3.3.0 using the following command:

```bash
rvm install 3.3.0
rvm use 3.3.0 --default #(if you don\'t want to set default don\'t write '--default')
```

### Step 2: Verify Ruby Installation

To confirm that Ruby 3.3.0 is installed correctly, you can list the available Ruby versions installed on your system:

```bash
rvm list
```

Ensure that Ruby 3.3.0 is listed and selected as the current version.

### Step 3: Fixing Common Installation Issues

If you encounter the error `Error running __rvm_make -j4...` while installing Ruby, it may be related to OpenSSL. To resolve this, follow these steps:

1. Install OpenSSL using RVM:

    ```bash
    rvm pkg install openssl
    ```

2. Reinstall Ruby 3.3.0 with OpenSSL configuration:

    ```bash
    rvm install 3.3.0 --with-openssl-dir=$rvm_path/usr
    ```

This should fix any issues related to OpenSSL during Ruby installation.

---

## Running the Application

Once the environment is set up, you can start the Rails application by following these steps:

1. Navigate to the root directory of your Rails project.

2. Run the following command to start the Rails server:

    ```bash
    rails server
    ```

3. After the server starts, open your web browser and go to:

    ```
    http://localhost:3000
    ```

This will load the application in your browser at the specified local address.

---

By following these instructions, you should have a fully functioning Ruby on Rails environment with Ruby 3.3.0 and Rails 7.1.3.4. If you run into any issues during installation or while starting the server, double-check the Ruby version using `rvm list` and ensure Rails is up to date with `gem update rails`.
