class Player
	attr_accessor :name, :letter, :word

	def initialize
		create_name
	end

	def guess_letter
		loop do
			puts "\nPlease enter a letter:"
			@letter = gets.chomp.downcase

			if @letter.between?("a", "z") && @letter.length == 1
				return letter
			else
				puts "#{@letter} is not a valid letter. Please try again."
			end
		end
	end

	private
	def create_name
		puts "Please enter your name:"
		@name = gets.chomp.capitalize
	end
end