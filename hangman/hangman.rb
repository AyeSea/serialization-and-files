require_relative "player"
require_relative "board"

class Hangman
	attr_accessor :player, :board, :guesses_left

	def initialize
		@player = Player.new
		@board = Board.new
		@guesses_left = @board.secret_word.length
	end


	def menu
		puts "Welcome to HANGMAN!"
		option = ''

		loop do
			puts "Please select an option from the following:"
			puts "1. Start a NEW game"
			puts "2. LOAD an existing game"
			puts "3. EXIT"

			option = gets.chomp.to_i
			break if (1..3).include?(option)
			puts "#{option} is not valid."
		end

		case option
		when 1
			puts "Starting a new game!"
			start_game
		when 2
			puts "Loading an existing game!"
			load_game
		when 3
			puts "Thanks for playing!"
			exit
		end
	end


	def start_game
		puts "You have #{@guesses_left} chances to guess the secret word!"
		player_turn
	end

	def load_game
		load_file = File.read("hangman_save").split(",")
		@player.name = load_file[0]
		@board.display_word = load_file[1].split("")
		@board.secret_word = load_file[2]
		@board.incorrect_words = load_file[3].split("")
		@board.updated_or_repeat = load_file[4]
		@guesses_left = load_file[5].to_i

		puts "Welcome back #{@player.name}!"
		player_turn
	end

	def player_turn
		until @guesses_left == 0
			@board.show_board
			save_prompt
			@board.update_board(@player.guess_letter)

			if win?
				puts "\nCongratulations! You guessed '#{@board.secret_word}' correctly! with #{@guesses_left} guesses left!"
				puts "Wow, you guessed every single letter correctly! Nice work!\n" if @guesses_left == @board.secret_word.length
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

	def save_prompt
		loop do
			puts "Would you like to save your game? Please enter YES or NO:"
			reply = gets.chomp.upcase

			if reply == "YES"
				save_game
				exit_prompt
				break
			elsif reply == "NO"
				break
			else
				puts "#{reply} is not a valid response. Please try again."
			end
		end
	end

	def exit_prompt
		loop do
			puts "Would you like to exit the program?"
			reply = gets.chomp.upcase
			exit if reply == "YES"
			break if reply == "NO"
			puts "Please type in YES or NO."
		end
	end

	def save_game
		File.open("hangman_save", "w") do |f|
		f.puts "#{@player.name},#{@board.display_word.join},#{@board.secret_word},#{@board.incorrect_words.join},#{@board.updated_or_repeat},#{@guesses_left}"
		end
	end
end

round_1 = Hangman.new
round_1.menu