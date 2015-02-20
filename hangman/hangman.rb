class NewGame
	attr_reader :dictionary, :secret_word

	def initialize
		open_dictionary
		create_secret_word
	end

	private
	def open_dictionary
		@dictionary = File.readlines("5desk.txt")
	end

	def create_secret_word
		@secret_word = ""

		loop do
			@secret_word = dictionary.sample
			break if @secret_word.length.between?(5, 12)
		end
	end

end

first_game = NewGame.new
puts first_game.secret_word