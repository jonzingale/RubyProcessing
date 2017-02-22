require 'csv'
require 'byebug'

FILES_PATH = File.expand_path('./../', __FILE__).freeze
file = "#{FILES_PATH}/lists.txt"

lines = []
File.open(file, 'r').each do |line|
  lines << line
end


byebug ; 2