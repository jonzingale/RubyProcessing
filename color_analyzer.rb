	class Pixels
		attr_accessor :pixels, :sorted
		
		def initialize
			loadPixels ; updatePixels
			@pixels = 0
			@sorted = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		def partition_colors
			@sorted = sort_colors(pixels.take(50))
		end

		def sort_colors(ary,accum=[])# :: [[Color,Num]]
			unless ary.empty?
				ary, ys = ary.partition{|i| i == ary.first}
				data = [ary.first,ary.count]
				sort_colors(ys,accum << data)
			end ; accum
		end

	end

	attr_reader :pxls
	def setup
		size(displayWidth/2.0, displayHeight)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 1

		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

		background(0)

		@pxls = Pixels.new
		@pxls.get_pixels(pixels)
	end

	def draw
		text("#{pxls.partition_colors}",100,100)
	end

