# frozen_string_literal: true

require_relative 'modules'
require 'json'

class Game
  include TextModule

  def initialize
    @word_collection = File.open('words.txt')
    @hangman_words = []
    @already_guessed = []
    @guess_word = nil
    @guess_word_with_blanks = nil
    @counter = 10
    @game_over = false
    start
  end

  def find_hangman_words
    @word_collection.map do |word|
      word = word.chomp
      @hangman_words.push(word) if word.length >= 5 && word.length <= 12
    end
  end

  def find_guess_word
    @guess_word = @hangman_words.sample
    @guess_word_with_blanks = @guess_word.gsub(/[A-Za-z]/, '_')
  end

  def user_letter
    user_letter_text
    puts "Wrong letters: #{@already_guessed}"
    letter = gets.chomp.downcase
  end

  def check_for_match(guess)
    if @guess_word.include?(guess) == true
      @guess_word.each_char.with_index do |char, index|
        @guess_word_with_blanks[index] = guess if guess == char
      end
    elsif guess == 'save'
      save_game
      game_saved_text
    else
      wrong_guess_text
      @counter -= 1
      puts "#{@counter} attempts left"
      @already_guessed.push(guess)
      check_loss
    end
    check_win
  end

  def check_win
    if @guess_word_with_blanks.include?('_') == false
      puts @guess_word
      announce_win
      @game_over = true
      new_game
    end
  end

  def check_loss
    if @counter.zero?
      announce_loss
      reveal_word(@guess_word)
      @game_over = true
      new_game
    end
  end

  def new_game
    new_game_text
    choice = gets.chomp.upcase
    if choice == 'Y'
      initialize
    else
      goodbye
    end
  end

  def turns
    puts @guess_word_with_blanks
    while @game_over == false
      letter = user_letter
      check_for_match(letter)
      break if @game_over == true
      puts '________________________'
      puts @guess_word_with_blanks
    end
  end

  def start
    instructions
    choice = gets.chomp.to_i
    if choice == 1
      find_hangman_words
      find_guess_word
      turns
    elsif choice == 2
      load_game
    else
      invalid_choice_text
    end
  end

  def save_game
    game = {
      already_guessed: @already_guessed,
      guess_word: @guess_word,
      guess_word_with_blanks: @guess_word_with_blanks,
      counter: @counter,
      game_over: @game_over
    }
    json = JSON.generate(game)
    Dir.mkdir 'saved_game' unless Dir.exist? 'saved_game'
    File.open('saved_game/game.json', 'w') { |file| file.puts json }
  end

  def load_game
    def construct(data_hash)
      @already_guessed = data_hash['already_guessed']
      @guess_word = data_hash['guess_word']
      @guess_word_with_blanks = data_hash['guess_word_with_blanks']
      @counter = data_hash['counter']
      @game_over = data_hash['game_over']
    end

    saved_file = File.read('saved_game/game.json')
    data_hash = JSON.parse(saved_file)
    construct(data_hash)
    turns
  end
end
