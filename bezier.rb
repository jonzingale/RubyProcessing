# This is an idea for 
# a bezier category

class Bezier

	def initialize(points)
		@points = points
		@count = points.count - 1
	end

	def to_s ; @points ; end

	def plot(t) # Sigma (1-t)^k*t^n-k*Pk
		scalars = (0..@count).map{|k| (1-t)**k * t**(@count-k) }
		it = @points.zip(scalars).map{|pts,s| pts.map{|xs| xs*s}}
		it.transpose.map{|i| i.inject :+}
	end
end
