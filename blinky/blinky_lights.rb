#components?
#optimizations
	#set color ahead?
	require (File.expand_path('blinky', File.dirname(__FILE__)))

		def setup
			size(800,800) ; background(0)
			frame_rate 3 # what ratio is there for frame_rate, board_size and e_ball?
			@e_ball = 5 # size of balls
			@blinky = Blinky.new(150,150) # boardsize (150 for size 800)
		end

		def pretty_print(board)
			
			board.each_with_index do |row,c_dex|
				row.each_with_index do |c,r_dex|
					params = [r_dex,c_dex].map{|i|i*@e_ball+20} + [@e_ball]*2
					rgb = (1..3).map{|i| c*(rand 255)}
					fill(*rgb) ; ellipse(*params)
				end
			end
		end

		def draw		
			pretty_print(@blinky.board)
			@blinky.go_team
		end
