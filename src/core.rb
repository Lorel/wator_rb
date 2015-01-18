class Core < Marsys::Core
	def initialize(options={})
		@agents = [:shark, :tuna]
		super(options)
	end
end