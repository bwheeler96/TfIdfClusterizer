class Cluster < Array
  attr_accessor :tf, :scores
  def initialize
    self.tf = Hash.new 0
    self.scores = []
  end 

  def <<(document)
    Tokenizer.tokens(document).each do |term|
      tf[term] += 1
    end
    super(document)
  end
end
