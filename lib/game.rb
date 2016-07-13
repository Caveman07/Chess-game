require_relative "table"
require_relative "players"
require 'yaml'

class Game
	include Enumerable

	def initialize
		   @table = Table.new
		   @player1  = Player.new(:white)
		   @player2 = Player.new(:black)
		   @players = [@player1,@player2]
		   @moving_player = nil
		   @other_player = nil
		   @game = :off
	end

	def start_the_game
		puts "Welcome to the game of chess!"
		puts "Do you wish to start a new game or continue with previously saved? Answer: n/c"
		answer = gets.chomp
		   if answer == "n" 
		   @table.clear_board	
		   start_the_new_game 
		   elsif answer == "c"
		    	 load_the_game
		   else 
		       "Your input is incorrect"
		       start_the_game
		   end 	 	
	end 

	def start_the_new_game
			@table.initial_setup
			@player1.status  = :moving
			playing_loop

	end

	def playing_loop
			@game = :on
			
			@table.print_board
			
			while @game == :on
				@moving_player = @players.select {|i| i.status == :moving}.first
				@other_player = @players.select {|i| i.status == nil}.first
				
				if @table.is_check_for?(@moving_player.color)
					if @table.is_mate_for?(@moving_player.color)
						puts "Mate! #{@moving_player.color.upcase} has lost!"
						puts "Do you want to play one more time? y/n"
						answer = gets.chomp.downcase
						answer == "y" ? start_the_game : @game = :off
						
					else 
						puts "Check! #{@moving_player.color.upcase} protect your King!"
						# perform_valid_move(valid_input,@moving_player)
						perform_valid_move(get_valid_input(@moving_player),@moving_player)

					end
				else

					perform_valid_move(get_valid_input(@moving_player),@moving_player)
				
				end
			end	
	end

	def get_valid_input(player)
		#return either 'save' or array with coords if input is valid
		puts "[#{player.color.upcase}] makes move (For example 'e2e3'). Or you can save the game by typing 'save'"
		input = gets.chomp
		if input == "save"
			return nil
		else 
			input = input.split(//)
			start_x = input[0].downcase.ord - 97
			start_y = input[1].to_i - 1
			dest_x = input[2].downcase.ord - 97
			dest_y = input[3].to_i  - 1
			coords = [start_x, start_y, dest_x, dest_y] 

			if input.size != 4
				puts "Input is unappropriate. Try again!"
				playing_loop
			
			elsif coords.any? {|i| !i.between?(0,7)}
				puts "Input is unappropriate. Try again!"
				playing_loop
			
			else 
				return coords 
			
			end
		end
	end

	def valid_move(coords, playerscolor)
		#performs move based on coords array but only if this move is valid. Otherwise return warning message and send back to the begining of loop

		original_field = @table.get_field_by_coords(coords[0],coords[1])
		destination_field = @table.get_field_by_coords(coords[2],coords[3])
		if original_field.figure != nil && original_field.figure.color == playerscolor && original_field.figure.possible_moves(@table).include?(destination_field) 
			@table.make_move(original_field.coords,destination_field.coords)
			if @table.is_check_for?(playerscolor)
			         	@table.undo_move
			         	puts "You can't make this move. It's check. Make proper move!!"
			         	playing_loop
	        end

		else 
		    puts "You can't perform this move! Try again"
		    playing_loop
		end
			
	end

	def perform_valid_move(coords,player)
	
		if coords == nil 
			save_game
			puts "Your game is saved. See you next time"
			@game = :off
							
		else
			valid_move(coords, player.color)
			@table.print_board
			@moving_player.status = nil
			@other_player.status = :moving
		end
	end



	def save_game
		Dir.mkdir('games') unless Dir.exist? 'games'
		filename = 'games/saved.yaml'
		File.open(filename, 'w') do |file|
			file.puts YAML.dump(self)
		end
	end

	def load_the_game
		content = File.open('games/saved.yaml','r') {|file| file.read}
		saved_game = YAML.load(content)
		saved_game.playing_loop

	end

end

test = Game.new
test.start_the_game

