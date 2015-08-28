# a class for color crawlers

class ColorCrawlers

	def trigs(theta)#:: Theta -> R2
	  %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def rgb_converter(m=0,n=0)
		k = get(m,n)
		r = 256 + k/(256**2)
		g = k/256 % 256
		b = k % 256
		[r,g,b]
	end

	def walker_y(p=@walker) # center of mass 
		# center of mass, not very robust, bug when all nears are the same.
		pair = @high_pair.nil? ? @walker : @high_pair
		e_ball = rand(100) # <- novel idea

		neighborhood = rootsUnity(17)+[[0,0]]
		rgb_weights = neighborhood.map do |s|
			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
			diff([rgb_converter(*unital_color), @m])
		end

		weight_total = rgb_weights.inject(0,:+)
		aTTw = neighborhood.zip(rgb_weights).inject([]) do |s,abw| 
			s << abw[0].map{|i|i*abw[1]}
		end.transpose.map{|i|i.inject :+}
		norm = aTTw.map{|i|-i*10/weight_total}
		@high_pair = norm.zip(pair).map{|rp|rp.inject :+}

		fill(255,255,255) ; text('y',*@high_pair)
	end


end