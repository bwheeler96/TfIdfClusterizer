require './clusterizer'
corpus = []
tests  = []

ARGV.each do |file|
  data = File.read(file).split("\n")
  corpus += data
  tests << [file, data]
end

c = Clusterizer.new(corpus: corpus, n_clusters: ARGV.length)
c.score!(tests)
