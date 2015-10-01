#components?
#optimizations
	#set color ahead?
	require (File.expand_path('blinky', File.dirname(__FILE__)))

		def setup
			size(900,900)
			background 0

			bs = [@width,@height].map{|s| s * 3 / 16}

			# frame_rate_hash = {1200 => 1, 1000 => 2, 800 => 3}
			# fr = frame_rate_hash[@height]

			# [800,1000,1200].map{|i| 7 - i / Math.log(i**30)}
			fr = (7 - @height / Math.log(@height**30)).to_i

			@blinky = Blinky.new(*bs)

			frame_rate fr
			@ball_size = 5
		end

		def pretty_print(board)
			
			board.each_with_index do |row,c_dex|
				row.each_with_index do |c,r_dex|
					params = [r_dex,c_dex].map{|i|i*@ball_size+20} + [@ball_size]*2
					rgb = (1..3).map{|i| c*(rand 255)}
					fill(*rgb) ; ellipse(*params)
				end
			end
		end

		def draw		
			pretty_print(@blinky.board)
			@blinky.go_team
		end
