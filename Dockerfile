# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables for RVM and Ruby installation
ENV RUBY_VERSION=3.3.0 \
    RAILS_ENV=development \
    DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y curl gnupg2 build-essential libssl-dev libreadline-dev \
    zlib1g-dev libpq-dev postgresql postgresql-contrib redis-server

# Install RVM (Ruby Version Manager)
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable

# Install Ruby and set it as default
RUN /bin/bash -l -c "rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default"

# Install Rails and bundler
RUN /bin/bash -l -c "gem install rails bundler"

# Create app directory and set it as the working directory
WORKDIR /code_legens

# Copy the Rails app to the container
COPY . /code_legens
RUN rm -rf *.pdf *.md

# Install Rails dependencies
RUN bundle install

# Expose the Redis and Postgres default ports
EXPOSE 3000 6379 5432

# Start PostgreSQL, Redis, and Rails server on container start
CMD service postgresql start && \
    service redis-server start && \
    rails db:create && \
    rails db:migrate && \
    rails db:seed && \
    rails server -b 0.0.0.0
