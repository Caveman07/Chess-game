class Field 

	attr_reader :coords, :color
	attr_accessor :figure

	def initialize(coords)
		@coords = coords
		@color = set_color(coords)
		@figure = nil
	end

	def set_color(coords)

		     if coords.y % 2 == 0
		     	coords.index % 2 == 0 ? "\u2593" : " "
		     else
		     	coords.index % 2 == 0 ? " " : "\u2593"
		     	 	 		 
		     end
	end

end
