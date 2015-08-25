# This is an idea for 
# a bezier category

# Sigma (1-t)^k*t^n-k*Pk

class Bezier

	def initialize(points)
		@points = points
		# num_points = points.count
	end

	def to_s ; @points ; end

	def plot(t)
		a = @points[2].map{ |p| t**2 * p }
		b = @points[1].map{ |p| (t-t**2) * p }
		c = @points[0].map{ |p| (1 - 2*t + t**2) * p }

		[a,b,c].transpose.map{|i| i.inject(:+) }
	end

end