load "environment.rb"
load "agent.rb"
load "settings.rb"

class Core
	attr_accessor :environment

	def initialize(options={})
		Settings.load!("config.yml")
		Settings.params.merge! options # override default settings
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

# m = Core.new
# m.run