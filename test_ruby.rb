#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'
require 'byebug'
WIDTH = 100 ; HEIGHT = 100
simplices = (0..6).map{|s| eval("SIMPLEX_#{s} = (0..#{s}).to_a")}.freeze

def abs(i) ; ((i**2)**0.5).to_i ; end
def is_compact?(simplex) ; del(del(simplex)).flatten.inject(0,:+) == 0 ; end

# 2-simplex
def split_simplex(simplex,line,p)
	faces = del(line.zip(simplex-line<<p).flatten)
	[faces[0],faces[2]]
end

def del(simplex)
	simplex[0].is_a?(Array) ? simplex.inject([]){|xs,s| xs + del(s) } :
	simplex.map.with_index{|s,i| simplex.reject{|x| x == s}.map{|j| j*(-1)**i } }
end

# 2-D simplices only
def add_p(simplex,line,p)
	edge = simplex - line << p
	del(simplex).inject([]) do |xs,s|
		cond = s.map{|j| abs(j) } == line
		cond ? xs + [[s[0], p],[p, s[1]]] : xs << s
	end + [edge, edge.map{|i|-i}]
end

# generalize to n-dimensions
def n_add_p(simplex,line,p)

end

def process
# del([0,1,3,4]).permutation.to_a.select{|s| s.include?([0,-1,-3]) && s.include?([1,3,4])}.map{|p| puts "#{p}"}.compact
# [[1, 3, 4], [0, -3, -4], [0, 1, 4], [0, -1, -3]]
# [[1, 3, 4], [0, -3, -4], [0, -1, -3], [0, 1, 4]]
# [[1, 3, 4], [0, 1, 4], [0, -3, -4], [0, -1, -3]]
# [[1, 3, 4], [0, 1, 4], [0, -1, -3], [0, -3, -4]]
# [[1, 3, 4], [0, -1, -3], [0, -3, -4], [0, 1, 4]]
# [[1, 3, 4], [0, -1, -3], [0, 1, 4], [0, -3, -4]]
# [[0, -3, -4], [1, 3, 4], [0, 1, 4], [0, -1, -3]]
# [[0, -3, -4], [1, 3, 4], [0, -1, -3], [0, 1, 4]]
# [[0, -3, -4], [0, 1, 4], [1, 3, 4], [0, -1, -3]]
# [[0, -3, -4], [0, 1, 4], [0, -1, -3], [1, 3, 4]]
# [[0, -3, -4], [0, -1, -3], [1, 3, 4], [0, 1, 4]]
# [[0, -3, -4], [0, -1, -3], [0, 1, 4], [1, 3, 4]]
# [[0, 1, 4], [1, 3, 4], [0, -3, -4], [0, -1, -3]]
# [[0, 1, 4], [1, 3, 4], [0, -1, -3], [0, -3, -4]]
# [[0, 1, 4], [0, -3, -4], [1, 3, 4], [0, -1, -3]]
# [[0, 1, 4], [0, -3, -4], [0, -1, -3], [1, 3, 4]]
# [[0, 1, 4], [0, -1, -3], [1, 3, 4], [0, -3, -4]]
# [[0, 1, 4], [0, -1, -3], [0, -3, -4], [1, 3, 4]]
# [[0, -1, -3], [1, 3, 4], [0, -3, -4], [0, 1, 4]]
# [[0, -1, -3], [1, 3, 4], [0, 1, 4], [0, -3, -4]]
# [[0, -1, -3], [0, -3, -4], [1, 3, 4], [0, 1, 4]]
# [[0, -1, -3], [0, -3, -4], [0, 1, 4], [1, 3, 4]]
# [[0, -1, -3], [0, 1, 4], [1, 3, 4], [0, -3, -4]]
# [[0, -1, -3], [0, 1, 4], [0, -3, -4], [1, 3, 4]]
	split_simplex([0,1,4],[0,4],2)

	# add_p(SIMPLEX_2, SIMPLEX_2.take(2), 99)
end

process

byebug ; 4