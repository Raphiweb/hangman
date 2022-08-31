# frozen_string_literal: true

module TextModule

  def instructions
    puts "////////////////////////////"
    puts "/// [1] - Start New Game ///"
    puts "/// [2] - Load Game      ///"
    puts "////////////////////////////"
    puts "remember to type \"save\" to save your game!"
  end

  def invalid_choice_text
    puts "Enter either \"1\" or \"2\"!"
  end

  def get_user_letter_text
    puts "Guess a letter!"
  end

  def wrong_guess_text
    puts "NOPE!"
  end

  def announce_win
    puts "Congrats! You got it!"
  end

  def announce_loss
    puts "You are out of guesses! You lost!"
  end

  def reveal_word(word)
    puts "The word was \"#{word}\"."
  end

  def new_game_text
    puts "Do you want to go back to the menu?"
    puts "Type \"Y\" for \"yes\", otherwise type something else."
  end

  def game_saved_text
    puts "Game saved."
  end

  def goodbye
    puts "Thanks for playing! Bye!"
  end
end
