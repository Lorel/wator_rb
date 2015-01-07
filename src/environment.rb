require 'pp'

class Environment
	attr_accessor :grid, :tunas, :sharks

	def initialize
		@size = Settings.params[:dimensions]
		@inhabitants = Settings.params[:inhabitants]
		@grid = Array.new(@size) { Array.new(@size ) }
		@size.times do |x|
			@size.times do |y|
				@grid[x][y] = Square.new(x,y)
			end
		end

		@tunas, @sharks = [], []

		squares = @grid.clone.flatten

		@inhabitants.times {
			tuna, shark = Tuna.new(self), Shark.new(self)
			@tunas << tuna
			@sharks << shark
			square = squares.delete(squares.sample)
			square.content = tuna
			tuna.square = square
			square = squares.delete(squares.sample)
			square.content = shark
			shark.square = square
		}
	end

	def turn
		@tunas.concat(@sharks).shuffle.each{ |a| a.turn }
	end

	def display
		puts @grid.inject(""){ |res,line| res + line.inject(""){ |res,square| res + square.char + " " } + "\n" } + "__" * @size + "\n"
	end

	def squares_around square
		squares = []
		(([0,square.x-1].max)..([@size-1,square.x+1].min)).each do |x|
			(([0,square.y-1].max)..([@size-1,square.y+1].min)).each do |y|
				squares << @grid[x][y] unless x == square.x && y == square.y
			end
		end
		squares
	end

	def empty_squares_around square
		squares_around(square).select{ |s| s.content.nil? }
	end	

	def squares_with_tuna_around square
		squares_around(square).select{ |s| s.content.is_a? Tuna }
	end


	class Square
		attr_accessor :x,:y,:content

		def initialize(x,y)
			@size = Settings.params[:dimensions]
			raise SquareOutOfRangeException.new unless ((0..(@size-1)).include?(x) || (0..(@size-1)).include?(y))
			@x, @y = x, y
		end

		def char
			case @content
				when Shark then "S"
				when Tuna then "T"
				else "-"
			end
		end
	end

	class SquareOutOfRangeException < Exception ; end
end
