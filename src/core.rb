load "environment.rb"
load "agent.rb"
load "settings.rb"

class Core
	def initialize
		Settings.load!("config.yml")
		puts "Iterations : #{Settings.params[:iterations]}"
		puts "SHARKS : breeding : #{Settings.params[:shark_breeding]} - starving : #{Settings.params[:starving]}"
		puts "TUNAS : breeding : #{Settings.params[:tuna_breeding]}"
		@iterations = Settings.params[:iterations]
		@environment = Environment.new
		@environment.display
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