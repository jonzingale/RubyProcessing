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
	@rand_c = (0..2).map{rand(255)} ; @i = 0
	PI = 3.1415926

def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end

def vects(d)
	Matrix.rows((0...2**d).map{|i|("%03d"%i.to_s(2)).split('').map(&:to_i)}) * 300
end

def rotation_tranny
	sin ,cos = trigs(@i*2*PI)
	# sc = trigs(@i*2*PI)
	Matrix.columns([[- sin,cos,0],[cos,sin,0],[0,0,1]])
end

	def process
		@i+=0.01
	
		shed = (rotation_tranny * VECT * 100).to_a.map(&:floor).take(2)
		translate = shed.zip([@w,@h]).map{|a,b|a+b}

		cube = vects(3).transpose
		turn = rotation_tranny * cube
	
		idea = turn.transpose.to_a.map{|i|i.take(2).map(&:floor)}
		translate = idea.map{|t|t.zip([@w,@h]).map{|a,b|a+b}}

	byebug
		end


process

byebug ; 4