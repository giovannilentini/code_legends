class MatchmakingController < ApplicationController
    def play_now
      @languages = ["Ruby", "Python", "JavaScript"]

      @selected_language = params[:language]
    end
  end
  