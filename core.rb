class Core < Marsys::Core
	def initialize(options={})
		@agents = [:shark, :tuna]
    @environment = Environment.new(@agents,options)
		super(options)
	end
end