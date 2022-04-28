require 'pry-byebug'

# This class controls the board logic
module Display
  def print_display(number_one, number_two, number_three, number_four)
    print '---------','---------','---------',"-----------\n"
    print "-   #{color(number_one)}    -","-   #{color(number_two)}   -","-   #{color(number_three)}    -","-   #{color(number_four)}   -\n"
    print '---------','---------','---------',"-----------\n"
  end

  def color(number)
    case number
    when 1
      '1'.blue
    when 2
      '2'.red
    when 3
      '3'.green
    when 4
      '4'.brown
    when 5
      '5'.magenta
    when 6
      '6'.cyan
    end
  end
end

# This class has the game data variables
class PlayGame
  include Display

  def initialize
    @secret_code_array = Array.new(4) { rand(1..6) }
    @secret_code =  @secret_code_array.join.to_i
    @round_number = 0
    @role = ''
  end

  def valid_num?(number)
    true if number >= 1 && number <= 6
  end

  def valid_length?(array)
    true if array.length == 4
  end

  def ask_code
    array = []
    until valid_length?(array)
      puts 'Please input code!'.bold
      temp_array = gets.chomp.split('')
      temp_array.each do |value|
        if valid_num?(value.to_i) && valid_length?(temp_array)
          array.push(value.to_i)
        else
          puts 'INVALID CODE'.red
          break
        end
      end
    end
    array
  end

  def common_numbers(array)
    (@secret_code_array & array).flat_map { |n| [n] * [@secret_code_array.count(n), array.count(n)].min }
  end

  def exact_matches(array)
    exact_matches = 0
    i = 0
    array.each do
      exact_matches += 1 if @secret_code_array[i] == array[i]
      i += 1
    end
    exact_matches
  end

  def print_matches(array)
    common_numbers = common_numbers(array)
    exact_matches = exact_matches(array)
    puts "You have #{exact_matches} exact matches!".blue
    puts "You have #{common_numbers.length - exact_matches} non-exact matches!".green
  end

  def new_secret_code
    @secret_code_array = Array.new(4) { rand(1..6) }
    @secret_code = @secret_code_array.join.to_i
  end

  def make_secret_code
    change_secret_code(ask_code)
  end

  def change_secret_code(array)
    @secret_code_array = array
    @secret_code = array.join.to_i
  end

  def array_to_i(array)
    array_i = []
    array.each do |value|
      array_i.push(value.to_i)
    end
    array_i
  end

  def role
    puts 'Would you like to make the code or guess the code? (make/guess)'
    role = gets.chomp
    case role
    when 'make'
      @role = 'make'
    when 'guess'
      @role = 'guess'
    else
      self.role
    end
  end

  def code_correct?(code)
    true if @secret_code == code
  end

  def code_correct(code, code_array)
    return nil unless @secret_code == code

    @round_number += 1
    print_display(code_array[0], code_array[1], code_array[2], code_array[3])
    puts "It's #{@secret_code}! The code was solved on round #{@round_number}!!"
    try_again
  end

  def game_over?
    return nil unless @round_number == 12

    puts "Sorry the code wasn't cracked! The code was #{@secret_code}!"
    true
  end

  def code_wrong_player(code, code_array)
    if game_over?
      try_again
    elsif @secret_code != code
      @round_number += 1
      print_display(code_array[0], code_array[1], code_array[2], code_array[3])
      puts "Guess again! (The code is #{@secret_code}.)"
      puts "Round #{@round_number}!".bold.underline
      print_matches(code_array)
      player_guess
    end
  end

  def code_wrong_computer(code, code_array)
    if game_over?
      try_again
    elsif @secret_code != code
      @round_number += 1
      print_display(code_array[0], code_array[1], code_array[2], code_array[3])
      puts "Round #{@round_number}!".bold.underline
      print_matches(code_array)
      sleep(0.2)
      computer_guess
    end
  end

  def player_guess
    guess_array = ask_code
    guess = guess_array.join.to_i
    code_correct(guess, guess_array)
    code_wrong_player(guess, guess_array)
  end

  # is working, gotta refactor
  def computer_logic
    final_array = []
    guess = final_array.join.to_i
    until code_correct?(guess) || game_over?
      i = 0
      @round_number += 1
      guess_array = Array.new(4) { rand(1..6) }
      guess_array.each do
        guess_array[i] = final_array[i] unless final_array[i].nil?
        final_array[i] = guess_array[i] if @secret_code_array[i] == guess_array[i]
        i += 1
      end
      print_display(guess_array[0], guess_array[1], guess_array[2], guess_array[3])
      puts "Round #{@round_number}!".bold.underline
      print_matches(guess_array)
      guess = final_array.join.to_i
      sleep(0.5)
    end
    code_correct(guess, final_array)
  end

  # def computer_logic
  #   guess = [].join.to_i
  #   until code_correct?(guess)
  #     @round_number += 1
  #     guess_array = Array.new(4) { rand(1..6) }
  #     common_numbers = common_numbers(guess_array)
  #     exact_matches = exact_matches(guess_array)
  #     print_display(guess_array[0], guess_array[1], guess_array[2], guess_array[3])
  #     puts "You have #{exact_matches} exact matches!".blue
  #     puts "You have #{common_numbers.length - exact_matches} non-exact matches!".green
  #     guess = save_array(guess_array).join.to_i
  #   end
  #   puts "You got it on round number #{@round_number}!"
  # end

  # def save_array(array)
  #   i = 0
  #   final_array = []
  #   array.each do
  #     array[i] = final_array[i] unless final_array[i].nil?
  #     final_array[i] = array[i] if @secret_code_array[i] == array[i]
  #     i += 1
  #   end
  #   print_display(array[0], array[1], array[2], array[3])
  #   final_array
  # end

  def play_game
    role
    case @role
    when 'guess'
      player_guess
    when 'make'
      make_secret_code
      computer_logic
      try_again if game_over?
    else
      role
    end
  end

  def try_again
    puts 'Play again? (y/n)'
    y_n = gets.chomp
    case y_n
    when 'y'
      @round_number = 0
      new_secret_code
      play_game
    when 'n'
      puts 'Thanks for playing!'.bold
    else
      try_again
    end
  end
end

class String
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def brown;          "\e[33m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def gray;           "\e[37m#{self}\e[0m" end
    
    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_brown;       "\e[43m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
    
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def blink;          "\e[5m#{self}\e[25m" end
    def reverse_color;  "\e[7m#{self}\e[27m" end
end

code = PlayGame.new
code.play_game
