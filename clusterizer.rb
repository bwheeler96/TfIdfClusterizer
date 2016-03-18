require 'stuff-classifier'
require './tokenizer'
require './cluster'
class Clusterizer
  attr_accessor :clusters, :corpus, :classified, :df 

  def initialize(n_clusters: 2, corpus:)
    self.df = Hash.new(0)
    self.corpus = corpus
    self.clusters = n_clusters.times.map do Cluster.new end
    corpus.each_with_index do |document, index|
      Tokenizer.tokens(document).uniq.each do |token|
        self.df[token] += 1
      end
      idx = index % n_clusters
      self.clusters[idx] << document
    end
    puts "Cluster lengths: #{clusters.map(&:length).join(' ')}"
    clusterize!
    puts "Cluster lengths: #{clusters.map(&:length).join(' ')}"
  end

  def to_s
    'Clusterizer'
  end

  def score!(labels)
    labels.each_with_index do |label, index|
      corpus = Set.new(label[1])
      clusters.each do |cluster|
        cluster.scores[index] = cluster.select { |x| corpus.member? x }.length
      end
    end
    puts labels.map { |x| x[0] }.join(' | ')
    puts '----------------------------------'
    clusters.each do |cluster|
      puts cluster.scores.join('    |    ')
      puts '---------------------------------'
    end
  end

  private

  def clusterize!
    moved = 1
    iterations = 0
    while moved > 0 && iterations < 20
      moved = 0
      new_clusters = clusters.map { Cluster.new }
      clusters.each_with_index do |cluster, index|
        cluster.each do |document|
          new_cluster = best_cluster(document, index)
          new_clusters[new_cluster] << document
          moved += 1 unless index == new_cluster
        end
      end
      self.clusters = new_clusters
      puts "Reclustered with #{moved} movements"
      iterations += 1
    end
  end

  def best_cluster(document, curr_index)
    scores = []
    tokens = Tokenizer.tokens(document)
    document_freqs = tokens.map do |token| 
      Math.log(corpus.length / df[token].to_f)
    end
    clusters.each_with_index do |cluster, index|
      term_freqs = tokens.map { |token| cluster.tf[token] }
      term_freqs.map! { |freq| freq - 1 } if index == curr_index
      score = (term_freqs.zip(document_freqs).map do |freq|
        freq[0] * freq[1]
      end.inject(:+) || 0) / cluster.length
      scores[index] = score
    end
    return scores.each_with_index.max[1]
  end
end
