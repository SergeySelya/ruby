require_relative 'parser'

url = ARGV[0]
file_name = ARGV[1]

Parser.new(url, file_name).categ_prod
