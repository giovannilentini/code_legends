FROM ruby:3.3.0

# Aggiorna i pacchetti del sistema e installa dipendenze necessarie
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  git \
  yarn

# Imposta la directory di lavoro all'interno del container
WORKDIR /app

# Copia il Gemfile e il Gemfile.lock per installare le gemme
COPY Gemfile Gemfile.lock ./

# Installa le gemme del progetto
RUN gem install bundler -v 2.4.9 
RUN bundle install

# Copia il resto dell'applicazione nel container
COPY . .

# Aggiungi il comando per eseguire la sincronizzazione dei file con il volume
CMD ["rails", "server", "-b", "0.0.0.0"]

# Porta esposta (predefinita per Rails)
EXPOSE 3000