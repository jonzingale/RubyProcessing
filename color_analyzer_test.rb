	require 'byebug'

	class Pixels
		attr_accessor :pixels, :sorted
		
		def initialize
			# loadPixels ; updatePixels
			@pixels = 0
			@sorted = []
		end

		def get_pixels(pixels)
			@pixels = pixels
		end

		def partition_colors
			@sorted = sort_colors(pixels)
		end

		def sort_colors(ary,accum=[])
			unless ary.empty?
				ary, ys = ary.partition{|i| i == ary.first}
				sort_colors(ys,accum << ary)
			end ; accum
		end
	end

	module Files
		require 'csv'
			FILES_PATH = File.expand_path('./../data', __FILE__)
			COLOR_FILE = "#{FILES_PATH}/color_distribution.csv"
			COLOR_FILE2 = "#{FILES_PATH}/color_distribution_2.csv"

	  def clean_csv(file) ; File.open(file, 'w'){''} ; end

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
	
				CSV.open(COLOR_FILE2, 'a'){|csv| csv << [color,count] }
				sort_colors_in_file(ary)
			end
		end
	end

	def pretty(it)
		it.map{|i| puts "#{i}"}.compact
	end


	include Files

	# sort_csv_processor

	# pixels = Pixels.new
	# ary = (0..200).map{ rand(100) }
	# pixels.get_pixels(ary)
	# it = pixels.partition_colors

	byebug ; 4
