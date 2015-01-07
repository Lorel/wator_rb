load "environment.rb"
load "agent.rb"

ITERATIONS = 10
DIMENSION = 50
INHABITANTS = 50
GESTATION = 3
STARVING = 3

class Core
	def initialize
		@environment = Environment.new
	end

	def run
		ITERATIONS.times {
			@environment.turn
			@environment.display
		}
	end
end

m = Core.new
m.run