require 'pp'
require 'colorize'

class Environment
	attr_accessor :grid, :tunas, :sharks

	def initialize
		@iteration = 0
		@size = Settings.params[:dimensions]
		@inhabitants = Settings.params[:inhabitants]
		@grid = Array.new(@size) { Array.new(@size) }
		@size.times do |x|
			@size.times do |y|
				@grid[x][y] = Square.new(x,y)
			end
		end

		@tunas, @sharks = [], []

		squares = @grid.clone.flatten

		(Settings.params[:tuna_inhabitants] || @inhabitants).times {
			tuna = Tuna.new(self)
			@tunas << tuna
			square = squares.delete(squares.sample)
			square.content = tuna
			tuna.square = square
		}

		(Settings.params[:shark_inhabitants] || @inhabitants).times {
			shark = Shark.new(self)
			@sharks << shark
			square = squares.delete(squares.sample)
			square.content = shark
			shark.square = square
		}
	end

	def to_json(options = {})
		{
			grid: 	@grid,
			tunas: 	@tunas,
			sharks: @sharks,
			tunas_census: tunas_census,
			sharks_census: sharks_census,
			iteration: @iteration
		}.to_json
	end

	def turn
		@iteration += 1
		[@tunas,@sharks].flatten.shuffle.each{ |a| a.turn }
	end

	def display
		puts @grid.inject(""){ |res,line| res + line.inject(""){ |res,square| res + square.char + " " } + "\n" } + "__" * @size + "\n"
		puts "Nombre de requins : #{@sharks.count}"
		puts "Nombre de thons : #{@tunas.count}"
		puts "Nombre de poissons : #{@grid.flatten.reject{|s| s.content.nil?}.count}"
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

	def tunas_census
		@tunas.census.map{ |a| -(a || 0) } 
	end

	def sharks_census
		@sharks.census 
	end

  Array.class_eval do
		def census 
			self.reduce([]){ |census,agent| census[agent.age] = (census[agent.age] || 0) + 1 ; census }
		end
	end

	class Square
		attr_accessor :x,:y,:content

		def initialize(x,y)
			@size = Settings.params[:dimensions]
			raise SquareOutOfRangeException.new unless ((0..(@size-1)).include?(x) || (0..(@size-1)).include?(y))
			@x, @y = x, y
		end

		def to_json(options = {})
			{
				content: 	@content,
				x: 				@x,
				y:  			@y
			}.to_json
		end

		def char
			case @content
				when Shark then "S".red
				when Tuna then "T".blue
				else "-"
			end
		end
	end

	class SquareOutOfRangeException < Exception ; end
end
