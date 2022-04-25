# 1 = blue
# 2 = red 
# 3 = green
# 4 = brown
# 5 = magenta
# 6 = cyan
require 'pry-byebug'

class Display
    def initialize 
    end 

    def print_display(number_one, number_two, number_three, number_four)
        print "---------","---------","---------", "-----------\n"
        print "-   #{color(number_one)}    -", "-   #{color(number_two)}   -", "-   #{color(number_three)}    -", "-   #{color(number_four)}   -\n"
        print "---------", "---------", "---------", "-----------\n"
    end

    def color(number)
        if number == 1
            "1".blue
        elsif number == 2
            "2".red
        elsif number == 3
            "3".green
        elsif number == 4
            "4".brown
        elsif number == 5
            "5".magenta
        elsif number == 6
            "6".cyan
        end  
    end 

end 

class PlayGame < Display
    def initialize 
        @secret_number_one = rand(1..6).to_s
        @secret_number_two = rand(1..6).to_s
        @secret_number_three = rand(1..6).to_s
        @secret_number_four = rand(1..6).to_s
        @secret_code_array_i = [@secret_number_one.to_i, @secret_number_two.to_i, @secret_number_three.to_i, @secret_number_four.to_i]
        @secret_code =  (@secret_number_one + @secret_number_two + @secret_number_three + @secret_number_four).to_i
        @round_number = 0
    end 

    def is_valid_num?(number)
        if number >= 1 && number <= 6 
            true
        end 
    end 

    def guess
        final_array = []
        until final_array.length == 4 do
            puts "Please guess a code!".bold
            number_array = gets.chomp.split("") 
            number_array.each do |value|
                if self.is_valid_num?(value.to_i) && number_array.length == 4 
                    final_array.push(value.to_i)
                else 
                    puts "INVALID INPUT AGAIN".red
                    break
                end     
            end 
        end 
        final_array
    end 

    def compare_array(array)
        common_numbers = (@secret_code_array_i & array).flat_map { |n| [n]*[@secret_code_array_i.count(n), array.count(n)].min }
        exact_matches = 0
        matches = 0
        i = 0
        array.each do 
            if @secret_code_array_i[i] == array[i]
                exact_matches += 1
            end 
            i += 1
        end 
        puts "You have #{exact_matches} exact matches!".blue
        puts "You have #{common_numbers.length - exact_matches} non-exact matches!".green
    end 

    def try_again
        puts "Play again? (y/n)"
        y_n = gets.chomp
        if y_n == 'y'
            @round_number = 0
            @secret_number_one = rand(1..6).to_s
            @secret_number_two = rand(1..6).to_s
            @secret_number_three = rand(1..6).to_s
            @secret_number_four = rand(1..6).to_s
            @secret_code_array_i = [@secret_number_one.to_i, @secret_number_two.to_i, @secret_number_three.to_i, @secret_number_four.to_i]
            @secret_code =  (@secret_number_one + @secret_number_two + @secret_number_three + @secret_number_four).to_i    
            play_game
        elsif y_n == 'n'
            puts "Thanks for playing!".bold
        else 
            try_again 
        end 
    end 

    def play_game 
        guess_array = self.guess
        guess = guess_array.join.to_i 
        if @secret_code == guess
            @round_number += 1
            self.print_display(guess_array[0],guess_array[1],guess_array[2],guess_array[3])
            puts "You're right it's #{@secret_code}! You got it on round #{@round_number}!!"
            try_again
        elsif @round_number == 12
            puts "Sorry you lose! The code was #{@secret_code}!"
            try_again
        else 
            @round_number += 1
            self.print_display(guess_array[0],guess_array[1],guess_array[2],guess_array[3])
            puts "Guess again! (The code is #{@secret_code}.)"
            puts "Round #{@round_number}!".bold.underline
            compare_array(guess_array)
            self.play_game
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
board = Display.new 
code.play_game

