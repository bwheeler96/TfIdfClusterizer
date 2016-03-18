require 'lingua/stemmer'
require 'set'
module Tokenizer
  STOP_WORDS = Set.new(File.read('stopwords.txt').scan(/\w+/))
  
  def self.tokens(document) 
    document = document.gsub(/[^a-zA-Z0-9]/, ' ').downcase.split
    document.reject! { |word| STOP_WORDS.include?(word) || word.length < 3 }
    Array(Lingua.stemmer(document))
  end
end
