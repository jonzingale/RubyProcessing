NEARS = [-1,0,1].product([-1,0,1]).select{|i| i!=[0,0]}

def setup
	background(0)
	size(displayWidth,displayHeight) # Home
	@wide, @high = 45, 45
	rand_board = (0...@wide).map{(0...@high).map{rand(2)}}
	@board = rand_board ; @i = 0
	@next_board = @board.map(&:dup)
	no_fill ; strokeWeight(1)
	frame_rate 6
end

def pretty_print
	@board.each_with_index do |row,c_dex|
		e_size = 20 # augmentation size
		row.each_with_index do |c,r_dex|
			stroke(c*rand(255),c*rand(255),c*rand(255))
			x,y = [r_dex,c_dex].map{|i|i*e_size+100}

			#mosaic
			middle_vals = [x,y,x,y].map{|coord| s = e_size*3 ; coord+(s/2-rand(s)) }
			curb = [x,y]+middle_vals+[x,y]
			fill(c*rand(255),c*rand(255),c*rand(255))
			bezier(*curb)
		end
	end
end

def cell_at(row, col) ; @board[row][col] ; end

def neighborhood(row, col)
	NEARS.map do |j, i|
		cell_at((row + j) % @high, (col + i) % @wide)
	end
end

def blink(state,neigh)
	sum = neigh.inject :+
	sum == 3 ? 1 : (sum==2&&state==1) ? 1 : 0 
end	
	
def go_team
	(0...@wide).each do |i| # col
		(0...@high).each do |j| # row
			cell = @board[j][i]
			neigh = neighborhood(j,i)
			@next_board[j][i] = blink cell, neigh
		end
	end

	@board = @next_board.map(&:dup)
end

def draw
	@i += 1
	pretty_print
	@board = go_team
end