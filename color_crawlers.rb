# a class for color crawlers

	# Todo or some Ideas:
	# better neighborhoods and guesses
	# sum along rays?
	# spider_plant like sporing?
	# diff of the diff?
	# remember the last n and if jostling make e_ball smaller.
	# modifiers: slash_n_burn(replaces with distant color);cultivator(smooths landscape);sorter
	# collaborative crawlers: scratch my back . .
	# grasshopper

module Maths
	PI = 3.1415926.freeze

	def trigs(theta)#:: Theta -> R2
	  %w(cos sin).map{|s| eval("Math.#{s} #{theta}")}
	end

	def rootsUnity(numbre)#::Int -> [trivalStar]
		(0...numbre).map{|i|trigs(i*2*PI/numbre)}
	end

	def diff_color(w)#::R^3->R^3->Distance
		norm = w.transpose.map{|p|p.inject(:-)**2}
		Math.sqrt(norm.inject :+)
	end
end

class ColorCrawlers
	include Maths
	attr_reader :desire, :sense, :position, :guess, :name

	def initialize(name,width,height)
		@desire = [235,18,85]
		@position = [width+400,height-200]
		@sense = [@positon,@desire]
		@guess = 100
		@name = name
	end

	def guess # to see what the distance is.
		@guess = @sense.map do |root,color|
			diff_color([@desire, color])
		end.min
	end

	def desired(mouse_color) ; @desire = mouse_color ; end
	def see(sense) ; @sense = sense ; end

	def look_z
		e_ball = rand(@guess)

		@interest = rootsUnity(17).unshift([0,0]).map do |inquiry|
			[inquiry, @position.zip(inquiry).map{|p,r|p+r*e_ball}]
		end
	end

	def motive_z # least difference
		step = self.sense.min_by{|r,color| diff_color([@desire, color])}[0]
		@position = step.zip(self.position).map{|rp|rp.inject :+}
	end

	# def walker_z(sampled) # least difference
	# 	pair = @low_pair.nil? ? @walker : @low_pair
	# 	e_ball = rand(100) # <- novel idea

	# 	@low_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
	# 		unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
	# 		diff([rgb_converter(*unital_color), @m])
	# 	end.zip(pair).map{|rp|rp.inject :+}
	# 	# fill(0,0,0) ; text('z',*@low_pair)
	# end

# 	def walker_y(p=@walker) # center of mass 
# 		# center of mass, not very robust, 
# 		# bug when all nears are the same.
# 		pair = @high_pair.nil? ? @walker : @high_pair
# 		e_ball = rand(100) # <- novel idea

# 		neighborhood = rootsUnity(17)+[[0,0]]
# 		rgb_weights = neighborhood.map do |s|
# 			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
# 			diff([rgb_converter(*unital_color), @m])
# 		end

# 		weight_total = rgb_weights.inject(0,:+)
# 		aTTw = neighborhood.zip(rgb_weights).inject([]) do |s,abw| 
# 			s << abw[0].map{|i|i*abw[1]}
# 		end.transpose.map{|i|i.inject :+}
# 		norm = aTTw.map{|i|-i*10/weight_total}
# 		@high_pair = norm.zip(pair).map{|rp|rp.inject :+}

# 		fill(255,255,255) ; text('y',*@high_pair)
# 	end

# 	def walker_w(p=@walker) # modifier
# 		pair = @mod_pair.nil? ? @walker : @mod_pair
# 		e_ball = rand(300) # <- novel idea

# 		@mod_pair = (rootsUnity(17)+[[0,0]]).min_by do |s|
# 			unital_color = pair.zip(s).map{|p,r|p+r*e_ball}
# 			diff([rgb_converter(*unital_color), @m])
# 		end.zip(pair).map{|rp|rp.inject :+}

# # try using get. then one can 'get' the whole screen with no params
# # saving this may make it possible to color!!!

# 		# loadPixels
# 			# set(*@mod_pair,0) #; x,y = @mod_pair.map(&:to_i)
# 		# 	it = pixels[y*width+x]
# 		# 	it = 0
# 		# 	save('/Users/Jon/Desktop/test.png')
# 		# 	@loaded = loadImage("/Users/Jon/Desktop/test.png")
# 		# updatePixels
# 		# text("#{it} is awesome",200,200)
# 		fill(0,0,0) ; text('w',*@mod_pair)
# 	end

end