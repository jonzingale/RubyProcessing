# Blinky Lights
#!/usr/bin/env ruby
#test ruby
# require 'ruby-2.0.0-p247'
require 'byebug'

WIDTH = 40 ; HEIGHT = 40

def pretty_print(board)
	board.map{|row| puts row.join('').gsub(/[01]/, '0' => '   ', '1' => ' * ') }
end

def blank_board
	(0...WIDTH).map{|i| (0...HEIGHT).map{|j| 0} }
end

def rand_board
	(0...WIDTH).map{|i| (0...HEIGHT).map{|j| rand(2)} }
end

def cell_at(row,col,board) ; board[row][col] ; end

def neighborhood(row,col,board)
	nears = (-1..1).inject([]){|is,i| is + (-1..1).map{|j| [i,j]} }
	nears = nears.select{|i| i!=[0,0]}
	nears.map{|ns| n,m = ns ; cell_at((row+n) % WIDTH,(col+m) % HEIGHT,board) }
end
	
def blink(state,neigh)
	sum=neigh.inject(0){|sum,i| sum+i}
	if ((sum==2)||(sum==3))&&state==1
		1
	elsif (sum==3)&&(state==0)
		1
	else
		0
	end			
end	

def coord_it(board)
	beers = (0...WIDTH).inject([]){|is,i| is << (0...HEIGHT).map{|j| [i,j]} }
	board.zip(beers).inject([]) do |bs,crazy|
		states,coords = crazy
		bs + states.zip(coords).map{|them| s,cd = them ; cd.unshift(s)}
	end
end

def update(board)
	b = board.take(WIDTH)
	bs = board.drop(WIDTH)
	board.empty? ? [] : update(bs).unshift(b)
end

def go_team(board)
	beers = (0...WIDTH).inject([]){|is,i| is + (0...HEIGHT).map{|j| [i,j]} }
	row,*rows=board
	b_row=beers.map do |xy|
		x,y = xy
		blink(cell_at(x,y,board),neighborhood(x,y,board) )
	end

	update(b_row)
end

board = rand_board ; @i=0

while @i<10**5
	sleep(0.1)
	system("clear")
	pretty_print(board)
	board = go_team(board)
end
