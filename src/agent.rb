class Agent < Marsys::Agent

	# def initialize(environment, square = nil)
	# 	super
	# end

	# def to_json(options = {})
	# 	super
	# end

	def give_birth
		@breeding += 1
		if @breeding > @breeding_time && @old_square # breeding time reached and old square not nil (so exists)
			@breeding = 0
			new_agent = self.class.new(@environment,@old_square)
			collection << new_agent
		end 
	end

	def turn
		super
		give_birth
	end
end