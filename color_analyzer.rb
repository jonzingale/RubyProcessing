	module Files
		require 'csv'
		FILES_PATH = File.expand_path('./../data', __FILE__)
		COLOR_FILE = "#{FILES_PATH}/color_distribution.csv"

		def direct_to_file(ary)
	  	File.open(COLOR_FILE, 'w') { |file| file.write('') }
	  	File.open(COLOR_FILE,'a') { |file| file << ary }
		end

	  def clean_csv ; File.open(COLOR_FILE, 'w') { |file| file.write('') } ; end

	  def pair_to_csv(color, count)
	  	File.open(COLOR_FILE,'a') { |file| file.write("#{color}, #{count}\n") }
	  end

	  def csv_to_ary
	  	ary = []
	  	ary << File.read(COLOR_FILE)
	  end

	end

	class Pixels
		include Files
		attr_accessor :pixels#, :distribution
		# @distribution to come from file

		CHUNK_SIZE = 2000# about the limit

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
				pair_to_csv(ary.first, ary.count)
				sort_colors_to_file(ys)
			end
		end

		# count the pixels and break them up into
		# digestable chunks to be sorted and stored.
		# requires reopening the file and working
		# with the repetitions.
		def sort_color_processor
			count = pixels.count
			chunks = count/CHUNK_SIZE

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

		# @pxls = Pixels.new
		# @pxls.get_pixels(pixels)
		# clean_csv ; @pxls.sort_color_processor

		it = csv_to_ary

		text("#{it[0..4]}",100,199)
	end

	def draw
		# text("#{pxls.distribution[10]}",100,100)
	end

