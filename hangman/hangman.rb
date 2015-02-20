require_relative "player"
require_relative "board"

class Hangman
	attr_reader :player, :board, :guesses_left

	def initialize
		@player = Player.new
		@board = Board.new
		@guesses_left = @board.secret_word.length
	end


	def menu
		puts "Welcome to HANGMAN!"
		option = ''

		until [1,2,3].include?(option)
			puts "Please select an option from the following:"
			puts "1. Start a NEW game"
			puts "2. LOAD an existing game"
			puts "3. EXIT"

			option = gets.chomp.to_i
			puts "#{option} is not valid."
		end

		case option
		when 1
			puts "Starting a new game!"
			start_game
		when 2
			puts "Loading an existing game!"
			#call the LOAD AN EXISTING GAME method
		when 3
			puts "Thanks for playing!"
			exit
		end
	end


	def start_game
		puts "You have #{@guesses_left} chances to guess the secret word!"

		until @guesses_left == 0
			@board.show_board
			@board.update_board(@player.guess_letter)

			if win?
				puts "\nCongratulations! You guessed '#{@board.secret_word}' correctly! in #{guesses_left} guesses!"
				puts "Wow! You're a champ for guessing every single letter correctly! Nice work!\n" if @guesses_left == @board.secret_word.length
				exit
			elsif @board.board_updated?
				puts "\n\nYou have #{@guesses_left} left.\n"
			else
				@guesses_left -= 1
				puts "You have #{@guesses_left} left."
			end
		end

		puts "GAME OVER! You ran out of guesses."
		puts "The secret word was #{@board.secret_word}!"
		puts "Try again!"
	end

	private
	def win?
		@board.display_word.join("") == @board.secret_word.downcase ? true : false
	end
end

round_1 = Hangman.new
round_1.menu