require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:letters].split(' ')
    if included?(@word.upcase, @grid)
      if english_word?(@word)
        @score = "Congratulations! #{@word} is a valid English word!"
      else
        @score = "Sorry but #{@word} does not seem to be a valid english word..."
      end
    else
      @score = "Sorry but #{@word} can't be built out of #{params[:letters]}"
    end
  end

  private

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
