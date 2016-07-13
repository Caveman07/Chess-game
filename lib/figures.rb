
require_relative "coords"


class Figure 

	attr_accessor :coords, :color
		def initialize(coords,color)
			@color = setcolor(color.to_s)
			@coords = coords
		end

		def setcolor(color)
			if color == "white" 
		     	return :white
			elsif color == "black"
		     	return :black
			else 
		   		raise "color is innapropriate"
		   	end
		end

		def checking_loop(table, horizontal_iteration_index, vertical_iteration_index, king)
			current_field = table.getfld(@coords)
			checking_array = [current_field]
			possible = []
		
			  #loop that checks everything to the right		
		      loop do 
		      	check = checking_array.shift
		      	current_field = table.get_field_by_coords(check.coords.x+horizontal_iteration_index, check.coords.y+vertical_iteration_index) if current_field != nil
		      	if current_field == nil #end of the board
		      		break
		      	else
		      		if current_field.figure == nil 	
		      	          possible.push(current_field) #means it is possible move
		      	          		king == true ? break : checking_array.push(current_field) #for the next iteration

		      	    elsif current_field.figure.color == self.color #can't move if the same color
		      	       break
		      	    
		      	    elsif current_field.figure.color != self.color
		      	    	possible.push(current_field) #it can eat opponents figure but move no further
		      	    	break
		      	    end	
		      	             	         
		        end
		      end
		      possible
		end      

	end	


class King < Figure
	
	attr_reader :picture


	def initialize(coords,color)
		
	 	super(coords,color)
		@picture = setpicture(color)
	end

	def setpicture(color)
		color == :white ? "\u2654" : "\u265A"
	end


	def possible_moves(table)

		possible = []
		possible.push(checking_loop(table,1,0,true), checking_loop(table,-1,0,true), checking_loop(table,-1,-1,true), checking_loop(table,1,1,true), checking_loop(table,-1,-1,true), checking_loop(table,1,-1,true), checking_loop(table,0,-1,true), checking_loop(table,0,1,true)).flatten
		possible.flatten

    end
	
end	

class Queen < Figure
	
	attr_reader :picture

	def initialize(coords,color)
		@picture = setpicture(@color)
		super(coords,color)

	end

	def setpicture(color)
		color == :white ? "\u2655" : "\u265B"
	end


	def possible_moves(table)

		possible = []
		possible.push(checking_loop(table,1,0,false), checking_loop(table,-1,0,false), checking_loop(table,-1,-1,false), checking_loop(table,1,1,false), checking_loop(table,1,-1,false), checking_loop(table,-1,1,false), checking_loop(table,0,-1,false), checking_loop(table,0,1,false)).flatten

		possible.flatten
	end 
end

class Rook < Figure
	
	attr_reader :picture

	def initialize(coords,color)
		
		super(coords,color)
		@picture = setpicture(color)
	end

	def setpicture(color)
		color == :white ? "\u2656" : "\u265C"
	end

    def possible_moves(table)

    	possible = []
		possible.push(checking_loop(table,1,0,false), checking_loop(table,-1,0,false),checking_loop(table,0,-1,false),checking_loop(table,0,1,false)).flatten
		possible.flatten
 
      end
end      

class Bishop < Figure
	
	attr_reader :picture

	def initialize(coords,color)
		
		super(coords,color)
		@picture = setpicture(color)
	end

	def setpicture(color)
		color == :white ? "\u2657" : "\u265D"
	end

	def possible_moves(table)

		possible = []
		possible.push(checking_loop(table,-1,-1,false), checking_loop(table,1,1,false), checking_loop(table,-1,+1,false), checking_loop(table,1,-1,false)).flatten		
		possible.flatten

	end	 
end

class Knight < Figure
	
	attr_reader :picture

	def initialize(coords,color)
		
		super(coords,color)
		@picture = setpicture(color)
	end

	def setpicture(color)
		color == :white ? "\u2658" : "\u265E"
	end

	def possible_moves(table)
		possible = [] 
		knight_moves = [[@coords.x+1, @coords.y+2],[@coords.x+1,@coords.y-2],[@coords.x-1,@coords.y+2],[@coords.x-1,@coords.y-2], [@coords.x+2,@coords.y-1],[@coords.x+2,@coords.y+1], [@coords.x-2,@coords.y+1], [@coords.x-2, @coords.y-1]]
		knight_moves.each do |i|
			next if table.get_field_by_coords(i[0],i[1]) == nil
			possible.push(table.get_field_by_coords(i[0],i[1])) if table.get_figure(i[0],i[1]) == nil || table.get_figure(i[0],i[1]).color != self.color
		end
		possible
	end
end

class Pawn < Figure
	
	attr_reader :picture

	def initialize(coords,color)
		super(coords,color)
		@picture = setpicture(color)
	end

	def setpicture(color)
		color == :white ? "\u2659" : "\u265F"
	end

    def possible_moves(table)
		possible = []
		if self.color == :white

			possible.push(table.get_field_by_coords(@coords.x-1,@coords.y+1)) if table.get_field_by_coords(@coords.x-1,@coords.y+1) != nil && table.get_figure(@coords.x-1,@coords.y+1) != nil && table.get_figure(@coords.x-1,@coords.y+1).color == :black
			possiblepush(table.get_field_by_coords(@coords.x+1,@coords.y+1)) if table.get_field_by_coords(@coords.x+1,@coords.y+1) != nil && table.get_figure(@coords.x+1,@coords.y+1) != nil && table.get_figure(@coords.x+1,@coords.y+1).color == :black
			possible.push(table.get_field_by_coords(@coords.x,@coords.y+1)) if table.get_field_by_coords(@coords.x,@coords.y+1) != nil && table.get_figure(@coords.x,@coords.y+1) == nil 
			possible.push(table.get_field_by_coords(@coords.x, @coords.y+2)) if self.coords.y == 1 && (table.get_figure(@coords.x, @coords.y+2) == nil && table.get_figure(@coords.x, @coords.y+1) == nil)
			
		else
			possible.push(table.get_field_by_coords(@coords.x-1,@coords.y-1)) if table.get_field_by_coords(@coords.x-1,@coords.y-1) != nil && table.get_figure(@coords.x-1,@coords.y-1) != nil && table.get_figure(@coords.x-1,@coords.y-1).color == :white
			possible.push(table.get_field_by_coords(@coords.x+1,@coords.y-1)) if table.get_field_by_coords(@coords.x+1,@coords.y-1) != nil && table.get_figure(@coords.x+1,@coords.y-1) != nil && table.get_figure(@coords.x+1,@coords.y-1).color == :white
			possible.push(table.get_field_by_coords(@coords.x,@coords.y-1)) if table.get_field_by_coords(@coords.x,@coords.y-1) != nil && table.get_figure(@coords.x,@coords.y-1) == nil 
			possible.push(table.get_field_by_coords(@coords.x, @coords.y-2)) if self.coords.y == 6 && (table.get_figure(@coords.x, @coords.y-2) == nil && table.get_figure(@coords.x, @coords.y-1) == nil)

		end
		possible
	end
end




