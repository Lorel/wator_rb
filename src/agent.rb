
class Agent
	attr_accessor :square

	def initialize(environment, square = nil)
		@breeding_time = Settings.params[:breeding]
		@breeding = 0
		@environment= environment
		@square = square
		@square.content = self if square # set square content with new fish if square provided
	end

	def to_json(options = {})
		{
			type: self.class.to_s.downcase
		}.to_json
	end

	def move
		@old_square = @square
		@square = @environment.empty_squares_around(@square).sample || @old_square
		@old_square = nil if @old_square == @square # no old_square if fish does not move
		@old_square.content = nil if @old_square # reset old_square content if @old_square exists (fish has moved)
		@square.content = self if @old_square # update square content if @old_square exists (fish has moved)
	end

	def give_birth
		@breeding += 1
		if @breeding > @breeding_time && @old_square # breeding time reached and old square not nil (so exists)
			@breeding = 0
			new_agent = self.class.new(@environment,@old_square)
			collection << new_agent
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
		@breeding_time = Settings.params[:shark_breeding]
		@starving_time = Settings.params[:starving]
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
	attr_accessor :alive

	def initialize(environment, square = nil)
		super(environment, square)
		@breeding_time = Settings.params[:tuna_breeding]
		@alive = true
	end

	def turn
		super if @alive
	end

	def die
		@alive = false
		super
	end
end