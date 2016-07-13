require "figures"
require "table"

describe King do 
	context "given initial board setup" do
		before(:context) do
			@table = Table.new
			@table.initial_setup
		end

		it "king possible moves shows empty array" do 
			king = @table.get_king(:white).first
			expect(king.possible_moves(@table).size).to be(0)
		end
	end
	context "given board situation" do 
		before(:context) do
			bishop = Bishop.new(ChessCoords.new(3,3),:white)
        	pawn = Pawn.new(ChessCoords.new(1,1),:white)
			black_knight = Knight.new(ChessCoords.new(4,5),:black)
			queen = Queen.new(ChessCoords.new(4,3),:white)
			@table = Table.new
			@table.put(bishop,ChessCoords.new(3,3))
			@table.put(pawn,ChessCoords.new(1,1))
			@table.put(black_knight,ChessCoords.new(4,5))
			@table.put(queen,ChessCoords.new(4,3))
	end
		it "queen possible moves shows 8 possible moves" do
			# @table.print_board 
			queen = @table.get_figure(4,3)
			expect(queen.possible_moves(@table).size).to be(21)
		end

		it "bishop possible moves shows 11 possible moves" do
			test_bishop = @table.get_figure(3,3)
			expect(test_bishop.possible_moves(@table).size).to be(11)
		end

	end

end	  
