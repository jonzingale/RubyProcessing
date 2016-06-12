	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		@w, @h = [width/2, height/2]
    frame_rate 10 ; background(0)
		stroke(210,100,100,100)

		# a + b*x + c*x**2
		@poly, @pt = [2,-4,0,1], rand(1000)
	end

	def abs(x); (x**2)**0.5 ; end
 
	def polyEval poly, x
		poly.map.with_index{ |a,i| a*x**i }.inject(:+)
	end

	def diff poly
		poly.drop(1).map.with_index{|a,i| a*(i+1)}
	end

	def newton(x)
		diffE = polyEval(diff(@poly),x).to_f
		@pt = x - 1/diffE * polyEval(@poly, x)
	end

	def draw
		clear
		newton(@pt)
		text("#{@pt.round(3)}",100,199)
	end