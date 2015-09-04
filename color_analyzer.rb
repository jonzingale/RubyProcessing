	module Files
		require 'csv'
			FILES_PATH = File.expand_path('./../data', __FILE__)
			COLOR_FILE = "#{FILES_PATH}/color_distribution.csv"
			COLOR_FILE2 = "#{FILES_PATH}/color_distribution_2.csv"

	  def clean_csv(file) ; File.open(file, 'w') ; end

	  def pair_to_csv(color, count)
	  	CSV.open(COLOR_FILE, 'a'){|csv| csv << [color,count] }
	  end

		# POSTPROCESSING
		def sort_csv_processor
			File.open(COLOR_FILE2, 'w'){''}
			csv = CSV.read(COLOR_FILE).map{|row| row.map(&:to_i)}
			sort_colors_in_file(csv)
		end
	
		def sort_colors_in_file(ary)
			unless ary.empty?
				ins, ary = ary.partition{|color,count| color == ary[0][0] }
	
				count = ins.transpose[1].inject :+
				color = ins[0][0]
				ins = nil

				CSV.open(COLOR_FILE2, 'a'){|csv| csv << [color,count] }
				sort_colors_in_file(ary)
			end
		end
	end

	class Pixels
		include Files
		attr_accessor :pixels#, :distribution
		# @distribution to come from file

		# CHUNK_SIZE = 2000# about the limit
		CHUNK_SIZE = 20# about the limit


		def initialize
			loadPixels ; updatePixels
			@pixels = 0
			@distribution = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		def sort_colors_to_file(ary=pixels[0..CHUNK_SIZE])
			unless ary.empty?
				ary, ys = ary.partition{|i| i == ary.first}

				color_count = ary[0], ary.count
				CSV.open(COLOR_FILE, 'a'){|csv| csv << color_count }
				ary = nil

				sort_colors_to_file(ys)
			end
		end

		# PREPROCESSES PIXELS
		def sort_color_processor
			count = pixels.count
			chunks = count/CHUNK_SIZE
			File.open(COLOR_FILE, 'w'){''}

			(0..chunks).each do |i|
				range = ((0+i)..(CHUNK_SIZE+i))
				sort_colors_to_file(pixels[range])
			end
		end

	end

	include Files
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
		@pxls.sort_color_processor
		sleep(2)
		sort_csv_processor
	end

	def draw
		text("#{pxls.pixels.count}",100,100)
	end

