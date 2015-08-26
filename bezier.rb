# This is an idea for 
# a bezier category

# Sigma (1-t)^k*t^n-k*Pk

class Bezier

	def pascal(i,num=[1])
		if num.count < i
			ary = num.unshift(0)

			mum = ary.map.with_index do |k,j|
				right = ary[j+1].nil? ? 0 : ary[j+1]
				ary[j] + right
			end

			pascal(i,mum)
		else
			num
		end
	end

	def polynomial
		n = @points.count
		pascal(n)
	end

	def initialize(points)
		@points = points
	end

	def to_s ; @points ; end

	def plot(t)
		a = @points[2].map{ |p| t**2 * p }
		b = @points[1].map{ |p| (t-t**2) * p }
		c = @points[0].map{ |p| (1 - 2*t + t**2) * p }

		[a,b,c].transpose.map{|i| i.inject(:+) }
	end

end