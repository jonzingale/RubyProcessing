#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'
require 'byebug'
require 'matrix'
	WIDTH = 100 ; HEIGHT = 100
  ID = Matrix.columns([[1,0,0],[0,1,0],[0,0,1]])
	VECT = Vector.elements([1,2,3])
	BECT = Vector.elements([4,5,6])
	@w,@h = [WIDTH,HEIGHT].map{|i|i/2.0}
	@rand_c = (0..2).map{rand(255)} ;  @i, @j, @k = [0]*3
	PI = 3.1415926

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def vects(d)
  Matrix.rows((0...2**d).map{|i|("%0#{d}d"%i.to_s(2)).split('').map(&:to_i)}) * 300
end

	def process

while @i > -1
	# @i+=0.01 ; @j+=0.02 ; @k+=0.04
	@i+=0.01 ; @j+=0.5 ; @k+=0.5
	sin1,cos1 = trigs(@i*2*PI)
	sin2,cos2 = trigs(@j*2*PI)
	sin3,cos3 = trigs(@k*2*PI) 

	rots_x = Matrix.columns([[cos1,sin1,0,0],[-sin1,cos1,0,0],
													 [0,0,1,0]      ,[0,0,0,1]])


	# 1,2,4,8
	bases = (0...4).map{|i|2**i}
###

		all_points = (0...2**4).inject([],:<<)
		triangles = all_points.inject([]){ |a,i| a+=(0..i).map{ |j| [i,j] } }
		edges = triangles.map{|a,b|[a,b] if bases.include?(a^b)}.compact

		e_coords = edges.map do |a|
			a.map{|x|("%04d" % x.to_s(2)).split('').map(&:to_i)}
		end

		turn_edges = e_coords.map do |s|
			s.map{|v| (rots_x * Vector.elements(v) * 300).to_a}
		end

		clean_edges = turn_edges.transpose.map{|i|i.map{|j|j.take(2).map(&:floor)}}

	translate = clean_edges.transpose.map do |edge|
		edge.zip([@w,@h]).map{ |e,x| [e[0]+@w,e[1]+@h] }
	end

	# translate.each{|edge|line(*edge)}


sleep(1)
	puts "#{translate}"
end

	end


process

byebug ; 4