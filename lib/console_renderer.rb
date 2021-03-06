require "rbconfig"

# Renders output to the console
class ConsoleRenderer
  # Are we running on a Windows machine?
  WIN_OS = Config::CONFIG["host_os"] =~ /mswin|mingw/

  # Standard puts functionality for adhoc text output
  def output(text)
    puts text
  end
  
  # Clears the terminal (OS safe)
  def clear
    WIN_OS ? system("cls") : system("clear")
  end
  
  # Outputs a blank line to the console
  def blank_line
    output ""
  end
  
  # Outputs the main welcome message
  def welcome
    clear
    output "Welcome to Hangman"
    output "=================="
    blank_line
  end
  
  # From a list of loaded player classes, display their names
  def players_list(players)
    output "Loaded Players"
    output "=============="
    
    File.open("log.txt", 'a') do |log|
      players.each_with_index do |player, x|
        output "#{x + 1}: #{player.new.name}"
        log.write "#{x + 1}: #{player.new.name}\r"
      end
    end 
    output "* No players loaded :o(" if players.empty?
    
    blank_line
  end
  
  # Display a list of errors while loading players
  def errors(errors)
    output "Errors Loading Players"
    output "======================"
    
    errors.each do |error|
      output "* #{error}"
    end
    output "* No errors to report :o)" if errors.empty?
    
    blank_line
  end
  
  # Render a frame of the game loop for the current player states
  def game_frame(states)
    clear
    
    states.each do |state|
      output state.player.name
      output state.current_pattern
      output "Correct: #{state.correct_guesses.join(' ')}"
      output "Incorrect: #{state.incorrect_guesses.join(' ')}"
      output Gallows.stages[state.incorrect_guesses.count]
      blank_line
    end
  end
end