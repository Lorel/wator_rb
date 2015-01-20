class Agent < Marsys::Agent

  attr_accessor :age

  def initialize(environment, square = nil)
    super
    @breeding_time = Marsys::Settings.params[:breeding]
    @breeding = 0

    @age = 0
  end

  def to_json(options = {})
    {
      type: self.class.to_s.downcase,
      age:  @age
    }.to_json
  end

  def move
    move_close
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
    @age += 1
    super
    give_birth
  end

  def die
    @square.content = nil
    collection.delete(self)
  end
end