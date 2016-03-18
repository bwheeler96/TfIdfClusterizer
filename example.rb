require './classify'

class Example
  attr_accessor :cluster
  def initialize
    self.cluster = Clusterizer.new(corpus: corpus)
  end

  def score
    self.cluster.score!([
                        ['bio', bio],
                        ['phys', phys]
    ])
  end

  def phys
    get_file('physics.txt')
  end

  def bio
    get_file('biology.txt')
  end

  def corpus
    bio + phys
  end

  def get_file(name)
    File.read(name).split("\n")
  end
end
