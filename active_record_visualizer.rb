	# An ActiveRecord Visualizer

	# forces ? birthday over a partitioning of space?
	GRAPH = eval(File.read("/Users/Jon/Desktop/arrows.txt")).freeze
	VERTS = GRAPH.map{|g|g[:vert]} # really better vertex_count. see get_coords

	def setup
		text_font create_font("SanSerif",8);
		# screen = [500,500] # test
		# screen = [3500,900] # another test
		screen = [1920,1080] #JackRabbit
		# screen = [1500,900] #HOME
		size(*screen)

		@w,@h = screen.map{|d| d/2}
		@i, @t = [0] * 2 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 2.5 ; colorMode(HSB,360,100,100)
		no_fill() ; no_stroke ; @xy = [0,0]
			
		cl = VERTS.map{|c| rand(30) }
		@cc = VERTS.map{|r| [(20 + rand(@w)) * 1.5,
												 (20 + rand(@h)) * 1.5] }.zip(cl)
	end

	def print_deg(x,y,data) ;text("#{counts = data[:counts].values}",x,y-20); end
	def draw ; clear ; plot_verts GRAPH ; end

	# in_coming blue, out_going red, both purple
	def size_v(data)
		counts = data[:counts].values
		counts.map{|i|[(Math.log(i+1) * 10)** 1.4] * 2}
	end

	def get_coords(coords_colors)
		coords, colors = coords_colors.transpose
		cd = coords.map{|x,y| [(x+(-1)**rand(2)/30.0) % (@w*2.0) ,
													 (y+(-1)**rand(2)/30.0) % (@h*2.0) ] }
		@cc = cd.zip(colors)
	end

	# data = {vert: arrows: counts:}
	def plot_verts(graph)
		graph.each_with_index do |data,index|
			@xy = get_coords(@cc).transpose[0][index]

			fill(200+@cc.transpose[1][index],50,93)
			text(data[:vert],*@xy) ; blue, red, purple = size_v(data)

			# print_deg(*@xy,data)
			fill(180,100,100,90) ; ellipse(*@xy,*blue) # blue
			fill(10,100,100,70)	; ellipse(*@xy,*red) # red
			fill(270,100,100,60) ; ellipse(*@xy,*purple) # purple
		end
	end
