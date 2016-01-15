class Poisson
	Epsilon = 10**-8

	attr_reader :ary, :components

	def initialize flakes, density = 3
		@density = density
		@num = flakes
		@components = ary.map{|p| (p * flakes).floor }
	end

	def fact(n) ; n=1 if n < 1 ; (1..n).inject :* ; end

	def poisson k
		num = @density**k
		denom = fact(k) * Math.exp(@density)
		num/denom.to_f
	end

	def ary # stops when values are too small
		(1..@num).take_while{|x| poisson(x) > Epsilon}.map{|k| poisson(k)}
	end

end
