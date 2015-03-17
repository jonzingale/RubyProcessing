# Blinky Lights
R = 100.freeze

def setup
	text_font create_font("SanSerif",60);
	background(10)
	# width, height
	# size(1920,1080) #JackRabbit
	size(1500,900) #HOME
  frame_rate 5
  fill 2.8, 2.6
  smooth
  @t=1 ; @i = 0
end

# Cell = {[Coord] => Value}
# Board = [Cell]

# neighborhood :: Cell -> Board -> [Cell]
def neighborhood(cell,board)
	{[x,y] => v} = cell
end






def draw
	x,y = [width/2,height/2] # center point
	g,b = [@t*2,@t*2.1] #greens blues
	@t = (@t+=1) % width # modular_index
	cos,sin = trigs(@t)


end



