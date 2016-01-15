	# can this be made condition based on version?
	require 'byebug'


		# TO DO :
		# Break into chunks and process it.
		# use file system over array structure
		# use recursion.

		# really there is no reason to use two separate sorts.
		# the first could just add a ,1 to the end of every
		# color and then begin the project of aggregating.

		# I really want to use Files 
		# as if they were arrays

	module Files
		require 'csv'
			FILES_PATH = File.expand_path('./../data', __FILE__)
			COLOR_FILE = "#{FILES_PATH}/color_distribution.csv"
			COLOR_FILE2 = "#{FILES_PATH}/color_distribution_2.csv"

		# POSTPROCESSING
		def sort_csv_processor
			File.open(COLOR_FILE2, 'w')
			csv = CSV.read(COLOR_FILE)
			sort_colors_in_file(csv)
		end
	
		def sort_colors_in_file(ary)
			until ary.empty?
				ins, ary = ary.partition{|color,count| color == ary[0][0] }
	
				count = ins.map{|col,cnt| cnt.to_i}.inject :+
				color = ins[0][0]
	
				CSV.open(COLOR_FILE2, 'a'){|csv| csv << [color,count] }
				sort_colors_in_file(ary)
			end
		end
	end

	include Files

	sort_csv_processor




	byebug ; 4
