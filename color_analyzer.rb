	module File
		FILES_PATH = File.expand_path('./files', __FILE__)

		# def hash_to_csv(file_name, key_values, headers)
		# 	file = "#{FILES_PATH}/#{file_name}" # :: String x [Hash] x [String] -> [Hash]
	 #  	CSV.open(file, 'w'){|csv| csv << headers.map(&:upcase) }
		# 	CSV.open(file, 'a'){|csv| key_values.map(&:values).each{|line| csv << [line].flatten}}
		# end
end

	end

	class Pixels
		attr_accessor :pixels, :distribution
		
		def initialize
			loadPixels ; updatePixels
			@pixels = 0
			@distribution = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		# better idea would be to cache the info
		# in a file.
		def partition_colors # these arrays are huge.
			# rand_sample = (0..500).map{|i| pixels[i]} 
			# limited_number = pixels.take(pixels.count/100)
			# @distribution = sort_colors(rand_sample)

			@distribution = sort_colors(pixels)
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
		size(displayWidth/2.4, displayHeight/1.4)
		@w, @h = [width/2.0, 0]
		@i = 0 ; @t = 0
    frame_rate 1

    background(0)
		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

		@img = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")
		image(@img,0,0)

		@pxls = Pixels.new
		@pxls.get_pixels(pixels)
		@pxls.partition_colors

	end

	def draw
		text("#{pxls.distribution[0..10]}",100,100)
	end

