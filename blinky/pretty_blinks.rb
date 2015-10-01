# A place to put pretty_prints for blinky
BALL_SIZE = 5

def pretty_print(board)
	board.each_with_index do |row,c_dex|
		row.each_with_index do |c,r_dex|
			params = [r_dex,c_dex].map{|i|i*BALL_SIZE+20} + [BALL_SIZE]*2
			rgb = (1..3).map{|i| c*(rand 255)}
			fill(*rgb) ; ellipse(*params)
		end
	end
end
