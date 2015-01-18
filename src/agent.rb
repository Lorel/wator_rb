class Agent < Marsys::Agent
	attr_accessor :square, :age

	def initialize(environment, square = nil)
		super
	end

	def to_json(options = {})
		super
	end

	def move
		super
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
		@age += 1
	end

	def die
		super
	end

	def collection
		super
	end
end