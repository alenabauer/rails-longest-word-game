require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @results = run_game(@word, @grid)
  end

  private

  def generate_grid
    9.times.map { ('A'..'Z').to_a.sample }
  end

  def check_dictionary(word)
    dict_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    entry_json = URI.open(dict_url).read
    entry = JSON.parse(entry_json)
    entry['found']
  end

  def check_grid(word, grid)
    letters = word.upcase.chars
    letters.all? { |letter| grid.include?(letter) && letters.count(letter) <= grid.count(letter) }
  end

  def run_game(attempt, grid)
    score = 0
    if !check_dictionary(attempt)
      message = "Sorry but #{attempt.upcase} does not seem to be a valid English word."
    elsif !check_grid(attempt, grid)
      message = "Sorry but #{attempt.upcase} can't be built from #{grid}"
    else
      message = 'Well done!'
      score = attempt.length * attempt.length
    end
    { score: score, message: message }
  end
end
