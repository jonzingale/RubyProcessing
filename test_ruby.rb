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

	# translate?
	rots_3 = Matrix.columns([[sin1 * cos2,0,0],[0,sin1 * sin2,0],[0,0,cos1]])
	rots_4 = Matrix.columns([[cos1*sin3,0,0,0],
													 [0,sin1*sin3,0,0],
													 [0,0,cos2*cos3,0],
													 [0,0,0,sin2*cos3]])


	hyper_cube = vects(4).transpose
	turn = rots_4 * hyper_cube

	idea = turn.transpose.to_a.map{|i|i.take(2).map(&:floor)}
	translate = idea.map{|t|t.zip([@w,@h]).map{|a,b|a+b}}
sleep(1)
	puts "#{translate}"
end

	end


process

byebug ; 4