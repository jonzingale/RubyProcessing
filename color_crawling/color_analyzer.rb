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
			until ary.empty?
				ins, ary = ary.partition{|color,count| color == ary[0][0] }
	
				count = ins.transpose[1].inject :+
				color = ins[0][0]

				CSV.open(COLOR_FILE2, 'a'){|csv| csv << [color,count] }
				sort_colors_in_file(ary)
			end
		end
	end

	class Pixels
		include Files
		attr_accessor :pixels, :info#, :distribution 
		# @distribution to come from file

		CHUNK_SIZE = 5000# about the limit
		# CHUNK_SIZE = 5# about the limit

		def initialize
			loadPixels ; updatePixels
			@pixels = 0
			@distribution = []
			@info = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		def sort_colors_to_file(ary)
			until ary.nil? || ary.empty?
				ary, ys = ary.partition{|i| i == ary.first}
				# @info << ary
				color_count = ary.first, ary.count
				CSV.open(COLOR_FILE, 'a'){|csv| csv << color_count }

				sort_colors_to_file(ys)
			end
		end

		# PREPROCESSES PIXELS
		def sort_color_processor(pixels)
			count = pixels.count
			chunks = count/CHUNK_SIZE # 20/5 == 4
			File.open(COLOR_FILE, 'w'){''}

			(0..chunks).each do |i|
				range = i*CHUNK_SIZE...CHUNK_SIZE*(i+1)
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
    frame_rate 10

    background(0) ; fill(0)
		colorMode(HSB,360,100,100,100)
	  text_font create_font("SanSerif",10)

		@img = loadImage("/Users/Jon/Desktop/scans/imgo_daniel.jpeg")
		image(@img,0,0)

		@pxls = Pixels.new
		# @pxls.sort_color_processor(pixels)
		# sleep(2)
		sort_csv_processor
	end

	def draw

		text("#{pxls.class}",100,100)
	end

