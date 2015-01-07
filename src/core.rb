load "environment.rb"
load "agent.rb"
load "settings.rb"

class Core
	def initialize
		Settings.load!("config.yml")
		@iterations = Settings.params[:iterations]
		@environment = Environment.new
	end
	def run
		@iterations.times {
			@environment.turn
			@environment.display
		}
	end
end

m = Core.new
m.run