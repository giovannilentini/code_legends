# Code Legends

Welcome to **Code Legends**, a Ruby on Rails application where users can challenge each other in coding duels. Each match generates a random challenge from a pool of existing challenges in the database, allowing users to test their coding skills in real-time. Additionally, users can connect, send friend requests, and challenge their friends to duels!

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Database Setup](#database-setup)
- [Usage](#usage)


---

## Features

- **Random Coding Duels**: Face off against other users in real-time coding duels where a random challenge is picked from the database.
- **Friend System**: Send and accept friend requests to create a network of coding buddies.
- **Challenge Friends**: Once friends, you can directly challenge your friends to a coding duel.
- **Real-Time Interaction**: Stay engaged with live duels and notifications for friend requests or challenges.
- **Leaderboard**: Compete with others to top the leaderboard by winning duels.

---

## Getting Started

### Prerequisites

Before setting up the project, make sure you have the following installed on your machine:

- **Ruby on Rails**
- **PostgreSQL**

For detailed instructions on installing Rails and PostgreSQL, please refer to the following files:

- [RAILS_README.md](./RAILS_README.md) – Rails installation and setup instructions.
- [POSTGRES_README.md](./POSTGRES_README.md) – PostgreSQL setup and configuration.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/giovannilentini/code_legends.git
   cd code_legends
   
2. **Install dependencies:**

    Run the following command to install the required gems:
    ```bash
    bundle install

3. **Install JavaScript dependencies:**

    ```bash
    yarn install

4. **Start redis server:**
    
    ```bash
    redis-server
   
---

### Database Setup

1. **PostgreSQL Setup**: Follow the instructions in [POSTGRES_README.md](./POSTGRES_README.md) to configure your PostgreSQL database.

2. **Database Migration**:

    After setting up PostgreSQL, run the following command to create and migrate the database:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed

---

### Usage

1. **Start the Rails server**:

    Run the following command to start the server:

    ```bash
    rails server

2. Open your browser and go to http://localhost:3000 to start using Code Legends!
