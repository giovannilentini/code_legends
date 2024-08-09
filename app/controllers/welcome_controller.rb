class WelcomeController < ApplicationController
  def index
    puts "HELLOOOOOOOOO"
    puts ENV["CODE_LEGENDS_DATABASE_PASSWORD"]
  end

end
