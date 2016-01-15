# counts up through rsa n's
	def setup
		background(0) ; @i = 1
		text_font create_font("SanSerif",100);
		@table = color_it(rsa_group(@i))
		square = [1000] * 2 ; size(*square)
		frame_rate 0.3 ; colorMode(HSB,360,100,100)
		no_stroke()
	end

	def pretty_print(board)
		fill(0,0,0) ; rect(0,0,width,height)
		scale = width/board[0].length*0.7
		board.each_with_index do |row,c_dex|
			row.each_with_index do |c,r_dex|
				x,y = [r_dex,c_dex].map{|i|i*scale+100}
				fill(c,100,100) ; ellipse(x,y,scale,scale)
			end
		end
	end

	def rsa_group(int)
		non_factors = (1...int).select{|i|i.gcd(int)==1}
		non_factors.inject([]){|is,i| is << (non_factors).map{|j| i*j%int} }#.sort
	end

	def color_it(table)
		roots_color = (1..table.length).map{|n|360*n/(table.length)}
		apply_color = table.map do |k|
			keyed = k.zip(table[0]).sort.zip(roots_color)
			keyed.sort_by{|i|i[0][1]}.map(&:last)
		end
	end

	def draw
		@table = color_it(rsa_group(@i+=1))
		pretty_print(@table)
		fill(30,100,100) ; text("#{@i}",width-200,height-200)
	end
