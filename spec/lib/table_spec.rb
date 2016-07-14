require "table"
require "coords"
require "figures"
require "field"

describe Table do 
	let(:pawn) {@table.get_figure(0,1)}
	let(:fields) {@table.get_figure(0,1).possible_moves(@table)}



	context "given initial setup" do 
		before(:context) do
			@table = Table.new
			@table.initial_setup 

		end

		it "'getfld(coords)' gets the field by passing new coords class" do 
			expect(@table.getfld(@table.get_field_by_coords(0,0).coords)).to eql(@table.field[0])
		end

		it "'get_field_by_coords(x,y)' gets the field by passing two coords" do 
			expect(@table.get_field_by_coords(0,0)).to eql(@table.field[0])
		end

		it "'possible_moves' gets the field by passing two coords" do 
			expect(@table.get_field_by_coords(0,0)).to eql(@table.field[0])
		end

		it "'get_figure' gets the figure by passing two coords" do 
			expect(@table.get_figure(0,0)).to eql(@table.field[0].figure)
		end

		it "possible moves of pawn1(0,1) returns the array of possible fields of size 2" do 
			expect(@table.get_figure(0,1).possible_moves(@table).size).to eql(2)
		end

	end	

	context "given an array of possible to move field" do
			
			before(:context) do
				@table = Table.new
				@table.initial_setup 
				@table.make_move(@table.get_figure(0,1).coords, @table.get_figure(0,1).possible_moves(@table)[0].coords)
				
			end
				
			it "moving the pawn to the first possible_moves field" do 
			expect(@table.get_figure(0,2).class.name).to eql("Pawn")
			expect(@table.get_figure(0,1)).to eql(nil)
			end

			it "succesfully undo move" do 
			@table.undo_move
			expect(@table.get_figure(0,1).class.name).to eql("Pawn")
			end		
	end

	context "given a mate situation on a board" do 

		  before(:context) do 
		  	@table = Table.new
 			@table.initial_setup

 			@table.getfld(ChessCoords.new(4,6)).figure = nil
 			@table.getfld(ChessCoords.new(4,1)).figure = nil
 			@table.make_move(ChessCoords.new(3,7), ChessCoords.new(7,3))
 			@table.make_move(ChessCoords.new(5,7), ChessCoords.new(2,4))
 			@table.make_move(ChessCoords.new(7,3), ChessCoords.new(5,1))

 		end

 		it "'is_check_for?' returns true" do
 			expect(@table.is_check_for?(@table.getfld(ChessCoords.new(4,0)).figure.color)).to be_truthy
 		end

 		it "'is_mate_for?' returns true" do 
 			expect(@table.is_mate_for?(@table.getfld(ChessCoords.new(4,0)).figure.color)).to be_truthy
 		end
 	end

 	context "given an open for castling situation on the left side of the board" do 

		  before(:context) do 
		  	@table = Table.new
 			@table.initial_setup

 			@table.getfld(ChessCoords.new(1,0)).figure = nil
 			@table.getfld(ChessCoords.new(2,0)).figure = nil
 			@table.getfld(ChessCoords.new(3,0)).figure = nil
 			@table.getfld(ChessCoords.new(5,0)).figure = nil
 			@table.getfld(ChessCoords.new(6,0)).figure = nil


 		end

 		it "'make_move' for king performs castling on the left side" do
 			@table.make_move(ChessCoords.new(4,0), ChessCoords.new(2,0))
 			@table.print_board
 			expect(@table.getfld(ChessCoords.new(2,0)).figure.class.name).to eq("King")
			expect(@table.getfld(ChessCoords.new(3,0)).figure.class.name).to eq("Rook")
 		end
 	end
 	
 	context "given an open for castling situation on the right side of the board" do 

		  before(:context) do 
		  	@table = Table.new
 			@table.initial_setup

 			@table.getfld(ChessCoords.new(1,0)).figure = nil
 			@table.getfld(ChessCoords.new(2,0)).figure = nil
 			@table.getfld(ChessCoords.new(3,0)).figure = nil
 			@table.getfld(ChessCoords.new(5,0)).figure = nil
 			@table.getfld(ChessCoords.new(6,0)).figure = nil


 		end


 		it "'make_move' for king performs castling on the right side" do
 			@table.make_move(ChessCoords.new(4,0), ChessCoords.new(6,0))
 			@table.print_board
 			expect(@table.getfld(ChessCoords.new(6,0)).figure.class.name).to eq("King")
			expect(@table.getfld(ChessCoords.new(5,0)).figure.class.name).to eq("Rook")
 		end
 	end
	
	context "given closed for castling situation on the right side of the board" do 

		  before(:context) do 
		  	@table = Table.new
 			@table.initial_setup

 			@table.getfld(ChessCoords.new(1,0)).figure = nil
 			@table.getfld(ChessCoords.new(5,0)).figure = nil


 		end


 		it "'make_move' for king on the right side raises error " do

 			expect(@table.make_move(ChessCoords.new(4,0), ChessCoords.new(6,0))).to raise_error
 			expect(@table.make_move(ChessCoords.new(4,0), ChessCoords.new(2,0))).to raise_error 
 			
 		end
 	end

 	context "given an open for castling situation on the right side of the board but king already moved" do 

		before(:context) do 
		  	@table = Table.new
 			@table.initial_setup

 			@table.getfld(ChessCoords.new(1,0)).figure = nil
 			@table.getfld(ChessCoords.new(2,0)).figure = nil
 			@table.getfld(ChessCoords.new(3,0)).figure = nil
 			@table.getfld(ChessCoords.new(5,0)).figure = nil
 			@table.getfld(ChessCoords.new(6,0)).figure = nil
 			@table.make_move(ChessCoords.new(4,0), ChessCoords.new(5,0))
 			@table.make_move(ChessCoords.new(5,0), ChessCoords.new(4,0))

 		end


 		it "'make_move' for king on the right doesn't perform castling " do

 			expect(@table.make_move(ChessCoords.new(4,0), ChessCoords.new(6,0))).to raise_error
 			
 		end
 	end

end
