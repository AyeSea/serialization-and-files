class Board
	attr_accessor :display_word, :incorrect_words, :secret_word, :dictionary, :letter, :updated_or_repeat

	def initialize
		open_dictionary
		create_secret_word
		@display_word = []
		@incorrect_words = []
		create_board(@secret_word)
	end

	def show_board
		puts "Current Board:"
		@display_word.each do |letter_cell|
			print "#{letter_cell} "
		end
		puts "\nIncorrect Letters: #{@incorrect_words.join(", ")}\n"
	end

	def update_board(letter)
		@letter = letter

		if @display_word.include?(@letter) || @incorrect_words.include?(@letter) 
			puts "You guessed #{@letter} already. Please select a new letter."
			@updated_or_repeat = true
		elsif @secret_word.downcase.include?(@letter)
			puts "\n#{@letter} is part of the word!\n"
			@updated_or_repeat = true
			updated_display_word = []

			@display_word.each_with_index do |letter_cell, i|
				if @secret_word.downcase[i] == @letter && @display_word[i] == "_"
					updated_display_word << @letter
				else
					updated_display_word << letter_cell
				end
			end

			@display_word = updated_display_word
		else
			puts "\nSorry, that letter is incorrect!\n"
			@incorrect_words << letter
			@updated_or_repeat = false
		end

		show_board
	end

	def board_updated?
		@updated_or_repeat ? true : false
	end

	private
	def open_dictionary
		@dictionary = File.readlines("5desk.txt")
	end

	def create_board(word)
		word.length.times do
			@display_word << "_"
		end
	end

	def create_secret_word
		@secret_word = ""

		loop do
			@secret_word = @dictionary.sample.chomp
			break if @secret_word.length.between?(5, 12)
		end
	end

end