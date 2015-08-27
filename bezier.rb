# This is an idea for 
# a bezier category

# Sigma (1-t)^k*t^n-k*Pk
class Bezier

	def initialize(points)
		@points = points
		@count = points.count - 1
	end

	def to_s ; @points ; end

	def plot(t) # (1-t)**(n-k) * t(n) * P0
		scalars = (0..@count).map{|k| (1-t)**k * t**(@count-k) }
		it = @points.zip(scalars).map{|pts,s| pts.map{|xs| xs*s}}
		it.transpose.map{|i| i.inject :+}
	end
end

# # for ruby 2.0
# require 'byebug'
# it = Bezier.new([[0,400],[200,0],[400,400]])
# it.plot(0.14)
#  (0..10).map{|t|it.plot(t/10.0)}.to_s
# byebug ; 4

