
require 'sinatra'
require 'sinatra/reloader' if development?
require './hangman2'

hangman = Hangman.new
gameover = false

get '/' do
  p hangman.answer
  if gameover
    hangman = Hangman.new
    gameover = false
  end

  guess = params[:guess]
  hangman = Hangman.new if guess.nil?
  hangman.try_to_guess(guess) if hangman.valid_guess?(guess)

  if !hangman.guess.include?('_')
    gameover = true
    erb :gameover, :locals => { :answer => hangman.answer,
                                :image_number => 6 - hangman.guesses_left,
                                :gameover_message => "You WIN! You WINNING WINNER!" }
  elsif hangman.guesses_left <= 0
    gameover = true
    erb :gameover, :locals => { :answer => hangman.answer,
                                :image_number => 6 - hangman.guesses_left,
                                :gameover_message => "Awww. You collected all six which means you didn't guess the word. :(" }
  else
    erb :index, :locals => { :word => hangman.word,
                             :guesses => hangman.guesses_left,
                             :image_number => 6 - hangman.guesses_left,
                             :guessed_characters => hangman.guessed_characters.upcase }
  end
end
