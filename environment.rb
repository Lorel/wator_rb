class Environment < Marsys::Environment

  def initialize(agents=[], options={})
    super(agents, options)
    census_methods_initialize
  end

  def add_hash_to_json
    puts "CALLED add_hash_to_json"
    hash = {}
    @agents_type.each do |type|
      hash[type.pluralize] = self.send(type.pluralize)                      # add collection of agents of this type
      hash["#{type}s_census".to_sym] = self.send("#{type}s_census".to_sym)  # add census informations for agents of this type
    end
    hash
  end

  def display_stats
    super
    @agents_type.each do |type|
      puts "#{type.to_s.pluralize.capitalize} population  : #{self.send(type.pluralize).count}"
    end
  end

  private
    def census_methods_initialize
      @agents_type.each do |type|
        # Create method #{type.pluralize}_census which return an Array
        # with population of type for each age range
        self.class.send( :define_method, "#{type.pluralize}_census", Proc.new{
          self.send(type.pluralize).census
        })
      end
    end

  Array.class_eval do
    def census 
      self.reduce([]){ |census,agent| census[agent.age] = (census[agent.age] || 0) + 1 ; census }
    end
  end
end
