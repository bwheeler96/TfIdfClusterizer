require 'mechanize'
agent = Mechanize.new

page = agent.get(ARGV[0])
text = page.css('#mw-content-text p').text.gsub(/\n+/, "\n").gsub(/\./, "\n")
text.split("\n").select! { |x| x.strip.length > 3 }.map! { |x| x.strip }.join("\n")
File.write(ARGV[1], text)
