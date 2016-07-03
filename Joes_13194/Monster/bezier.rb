class Bezier
	attr_reader :points
	def initialize(points)
		@points = points
		@count = points.count - 1
	end

	def coords(coords) ; @points = [coords] + @points.drop(1) ; end 

	def plot(time) # Sigma (1-t)^k * t^(n-k) * Pk
		scalars = (0..@count).map{|k| (1-time)**k * time**(@count-k) }
		it = @points.zip(scalars).map{|pts,s| pts.map{|xs| xs*s}}
		it.transpose.map{|i| i.inject :+}
	end
end
