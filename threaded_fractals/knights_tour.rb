# Knights Tour
class PrimeWindow
	require 'matrix'
	
	attr_accessor :dims, :pxl
	def initialize(width, height)
		@w, @h = get_dims(width, height)
		# dont let rando be < 2 or as big as dim
		@rando = Matrix.rows([[rand(@w-2)+2,0],[0,rand(@h-2)+2]])
		@seed = Matrix.rows([[1,0],[0,1]])
		@matx = @rando + @seed
		@dims = @w, @h
		@pxl = 1, 1
	end

	def update_vect
		top, bot = (@rando + @matx ).to_a
		w, h = top[0], bot[1]
		@pxl = [w % @w, h % @h]
		@matx = Matrix.rows([[@pxl[0],0],[0,@pxl[1]]])
	end

	def get_dims w, h
		h = prime_size h
		w = h == w ? prime_size(w-1) : prime_size(w)
		[w, h]
	end

	def prime_size d
		prime?(d) ? d : prime_size(d-1)
	end

	def prime? n
		t = 1 ; root_n = t+=1 while t**2 <= n 
		!(2..root_n).any?{|t| n % t == 0}
	end
end

def setup
	@window = PrimeWindow.new(displayWidth, displayHeight)
	dimensions = @window.dims ; size(*dimensions)

	text_font create_font("SanSerif",100)
	colorMode(HSB,360,100,100)
	frame_rate 20
	background 0
  load_pixels

  8.times{|thread| Thread.new { puts_pixel thread }}
end

def puts_pixel thread
	window = PrimeWindow.new(displayWidth, displayHeight)

	until window.pxl == [0,0]
		window.update_vect
		w, h = window.pxl
		color = color(360/(thread+1),70,100)
		pixels[w+h*@width] = color
	end
end

def draw
	update_pixels
end
