

class ChessCoords
	attr_reader :x, :y, :index

	def initialize(x,y)
		@x = x 
		@y = y
		@index = coords_to_index
		
	end 

	def validate(i)
		#validate if i is numeric
		#why would I need that? 
	end

	def coords_to_index
		(8 * self.y) + self.x
	end


end
