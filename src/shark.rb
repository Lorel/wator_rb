class Shark < Marsys::Agent

  def initialize(environment, square = nil)
    super(environment, square)
    @breeding_time = Marsys::Settings.params[:shark_breeding]
    @starving_time = Marsys::Settings.params[:starving]
    @starving = 0
    @color = :red
  end

  def eat
    @starving += 1
    unless @environment.squares_around_with_tuna(@square).empty?
      @environment.squares_around_with_tuna(@square).sample.content.die
      @starving = 0
    end
  end

  def turn
    eat
    super
    die unless @starving < @starving_time
  end
end