require_relative 'field'
require_relative 'coords'
require_relative 'figures'


class Table
	include Enumerable
	attr_reader  :history
	attr_accessor :field
    def initialize 
         @width = 8 
         @height = 8
         @size = @width * @height 
         @field = Array.new(@size).map.with_index do |_, i|
         	Field.new(index_to_chess_coords(i))
         end
         @history  = []
     end

     def index_to_chess_coords(index)
     		x = index % @width 
     		y = index/@width
     		ChessCoords.new(x,y)
     end

     def print_board
     	
     	field_width = 5
     	half_width = field_width/2

     	puts
     	puts "#{' '*(field_width+2)}#{print_letters}"
     	puts  "#{' '*(half_width+2)}#{"\u2581"*(@width*field_width)}#{"\u2581"*(half_width)}#{' '*(half_width)}"

     	(@height-1).downto(0) do |row|

     		line_without_figure = ""
     		line_with_figure = ""

     		(0).upto(@width-1) do | col |

     			coords = ChessCoords.new(col,row)
     			field = getfld(coords)
     			
     			color = getfld(coords).color
     			figure = getfld(coords).figure
     			line_without_figure += color*field_width
     			if figure == nil 
     			 line_with_figure += color*field_width 
     			   else 
     			   	picture = getfld(coords).figure.picture
     			   	line_with_figure += color*half_width
     			   	line_with_figure += picture
     			   	line_with_figure += color*half_width
     			end
     		end
     	puts "    #{"\u258F"}#{line_without_figure}#{"\u2595"}"
     	puts "  #{row+1} #{"\u258F"}#{line_with_figure}#{"\u2595"} #{row+1} "
     	puts "    #{"\u258F"}#{line_without_figure}#{"\u2595"}"
		end

		puts  "#{' '*(half_width+2)}#{"\u2594"*(@width*field_width)}#{"\u2594"*(half_width)}#{' '*(half_width)}"
		puts "#{' '*(field_width+2)}#{print_letters}"

	end	

     def getfld(coords)
     	field[coords.index]

     end

     def get_field_by_coords(x,y)
     	validated = validate(x,y)
     	unless validated == nil
     	   thisfield = ChessCoords.new(validated[0],validated[1])
     	   getfld(thisfield)
     	end
     end

     def validate(x,y)
     	array = []
     	 if x.between?(0,7) && y.between?(0,7) 
     	 array.push(x,y)
     	 return array 
     	 else 
     	 	return nil
     	 end
     end

     def get_figure(x,y)
		get_field_by_coords(x,y).figure if get_field_by_coords(x,y).figure != nil
	 end

     def print_letters
     	letters = ('A'..'H').to_a
     	half_width = @width/2
     	letters.join(' '*half_width)
     end

     def get_all_figures_of(figcolor)
     	figures = []
     	fields = @field.each do |i| 
     		next if i.figure == nil
     		if i.figure.color == figcolor
     			figures.push(i)
     		end
     	end
     	figures.map {|i| i.figure}
     end

     def get_king(color)
     	get_all_figures_of(color).select {|i| i.is_a? King}
     end

     def put(putfigure,coords)
     	getfld(coords).figure = putfigure
	 end

	 def initial_setup
	 	put(Rook.new(ChessCoords.new(0,0),:white),ChessCoords.new(0,0))
	 	put(Knight.new(ChessCoords.new(1,0),:white),ChessCoords.new(1,0))
	 	put(Bishop.new(ChessCoords.new(2,0), :white),ChessCoords.new(2,0))
	 	put(Queen.new(ChessCoords.new(3,0), :white),ChessCoords.new(3,0))
	 	put(King.new(ChessCoords.new(4,0), :white),ChessCoords.new(4,0))
	 	put(Bishop.new(ChessCoords.new(5,0),:white),ChessCoords.new(5,0))
	 	put(Knight.new(ChessCoords.new(6,0),:white),ChessCoords.new(6,0))
	 	put(Rook.new(ChessCoords.new(7,0),:white),ChessCoords.new(7,0))
	 	for i in 0..7 do 
	 		put(Pawn.new(ChessCoords.new(i,1),:white),ChessCoords.new(i,1))
	 	end

	 	for i in 0..7 do 
	 		put(Pawn.new(ChessCoords.new(i,6),:black),ChessCoords.new(i,6))
	 	end
        put(Rook.new(ChessCoords.new(0,7),:black),ChessCoords.new(0,7))
	 	put(Knight.new(ChessCoords.new(1,7),:black),ChessCoords.new(1,7))
	 	put(Bishop.new(ChessCoords.new(2,7),:black),ChessCoords.new(2,7))
	 	put(Queen.new(ChessCoords.new(3,7),:black),ChessCoords.new(3,7))
	 	put(King.new(ChessCoords.new(4,7),:black),ChessCoords.new(4,7))
	 	put(Bishop.new(ChessCoords.new(5,7),:black),ChessCoords.new(5,7))
	 	put(Knight.new(ChessCoords.new(6,7),:black),ChessCoords.new(6,7))
	 	put(Rook.new(ChessCoords.new(7,7),:black),ChessCoords.new(7,7))
	 	
		@history.push(Marshal.dump(@field))

	 end

	 def is_check_for?(color)
	 	color == :black ? opposite_color = :white : opposite_color = :black 
		all_possible_moves = []
		get_all_figures_of(opposite_color).each do |i|
			all_possible_moves.concat(i.possible_moves(self))
		end

		all_possible_moves.any? {|i| i.coords.index == get_king(color).first.coords.index }
	end

	def is_mate_for?(color)
		checks = []
		get_all_figures_of(color).each do |figure|


				figure.possible_moves(self).each do |field|
					koords = figure.coords
					make_move(figure.coords,field.coords)
					checks.push(is_check_for?(color))
					undo_move
					figure.coords = koords
					
				end
			end
			
		checks.any? {|i| i == false} ? false : true
	end

	def make_move(coords1,coords2)
     	legal = []
     	legal.concat(getfld(coords1).figure.possible_moves(self))
     	
  
     	if legal.include?(getfld(coords2))

     		getfld(coords2).figure = getfld(coords1).figure
     		getfld(coords2).figure.coords = coords2
     		getfld(coords1).figure = nil
     		@history.push(Marshal.dump(@field))


     	else
     		raise "Move is not possible"
     	end
     end	

	def undo_move	
		@history.pop
		@field = Marshal.load(@history[-1])
	end

	def clear_board
		@field.each {|field| field.figure = nil }
	end

 end






