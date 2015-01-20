class Tuna < Agent
  attr_accessor :alive

  def initialize(environment, square = nil)
    super(environment, square)
    @breeding_time = Marsys::Settings.params[:tuna_breeding]
    @alive = true
    @color = :blue
  end

  def turn
    super if @alive
  end

  def die
    @alive = false
    super
  end
end