require './tokenizer'

sentence = 'This is [1] a very (mangled sentence), in the sense that; it has,,,... much punctuation.1'
puts "Tokenizing: #{sentence}"
puts Tokenizer.tokenize(sentence)
