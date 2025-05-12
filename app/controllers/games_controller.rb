class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    @word = (params[:word] || "").strip.downcase
    @letters = (params[:letters] || "").split(",")

    if !valid_word?(@word, @letters)
      @score = 0
      @message = "Invalid word — it doesn't match the grid."
    elsif !english_word?(@word)
      @score = 0
      @message = "Not a valid English word."
    else
      @score = @word.length
      @message = "Congratulations! #{@word.upcase} is valid."
    end
  end  # << This was missing!

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)

    puts "API result for '#{word}': #{json}"

    json["found"] == true
  rescue OpenURI::HTTPError => e
    puts "API error for '#{word}': #{e.message}"
    false
  end

  def valid_word?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end
end
