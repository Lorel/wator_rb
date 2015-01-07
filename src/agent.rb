
class Agent
	attr_accessor :square

	def initialize(environment, square = nil)
		@gestation_time = GESTATION
		@gestation = 0
		@environment= environment
		@square = square
		@square.content = self if square
	end

	def move
		@old_square = @square
		@square = @environment.empty_squares_around(@square).sample || @old_square
		@old_square = nil if @old_square == @square
	end

	def give_birth
		@gestation += 1
		if @gestation > @gestation_time && @old_square
			@gestation = 0
			new_agent = self.class.new(@environment,@old_square)
			collection << new_agent
			return new_agent
		end 
	end

	def turn
		move
		give_birth
	end

	def die
		@square.content = nil
		collection.delete(self)
	end

	def collection
		@environment.send((self.class.to_s.downcase + "s").to_sym)
	end
end

class Shark < Agent
	def initialize(environment, square = nil)
		super(environment, square)
		@starving_time = STARVING
		@starving = 0
	end

	def eat
		@starving += 1
		unless @environment.squares_with_tuna_around(@square).empty?
			@environment.squares_with_tuna_around(@square).sample.content.die
			@starving = 0
		end
	end

	def turn
		eat
		super
		die if @starving == @starving_time
	end
end


class Tuna < Agent
	def initialize(environment, square = nil)
		super(environment, square)
	end
end