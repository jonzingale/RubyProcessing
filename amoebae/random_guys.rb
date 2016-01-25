class Walker
	attr_reader :color, :size, :coords
	def initialize(width, height)
		@color = [rand(360), rand(100), rand(30)+70, rand(70) + 30]
		@width, @height = width, height
		@coords = width/2, height/2
		@size = rand(15) + 3
	end

	def set_coords(x, y) ; @coords = x, y ; end

	def walk
		x, y = @coords.map{|v| v + 2 * (rand(5) - 2) }
		@coords = x % @width, y % @height
	end
end

	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,100)
		background(0) ; frame_rate 20
	  text_font create_font("SanSerif",10)

	  @walkers = [0,1].map{ Walker.new(width, height) }
	end

	Eb = 0.1.freeze # attractive constant
	def diff(x, y, w, z) ; [Eb * (w-x) + x, Eb * (z-y) + y] ; end
	def counter(n=3600) ; @i = ((@i||0) + 1) % n ; end
	def abs(n) ; (n**2)**0.5 ; end 

	def spawn
		if @i % 10 == 0 && @walkers.count < 3000 
			@walkers << Walker.new(width, height)
		end
	end

	def lightning
		range = @walkers.count
		me, you = [0,1].map{ @walkers[rand(range)]}
		stroke(*me.color) ; stroke_width(2)
		vect, wect = [me.coords, you.coords]
		line(*vect,*wect)

		# keep those that zap close.	
		mes = diff(*vect, *wect)
		yous = diff(*wect, *vect)
		me.set_coords(*mes)
		you.set_coords(*yous)
	end

	def render
		no_stroke
		@walkers.each do |walker|
			fill(*walker.color)
			size = [walker.size] * 2
			ellipse(*walker.coords,*size)
			walker.walk
		end
	end

	def draw
		clear
		counter
		spawn
		render
		lightning
	end
