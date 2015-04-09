# Todo: auto rescaling; change on the fly
	def setup
		text_font create_font("SanSerif",10);
		square = [800] * 2  + [P3D]
		@w,@h = [square[0]/2] * 2
		size(*square) ; background(0)
		frame_rate 3 ; colorMode(HSB,360,100,100)
		@table = color_it(rsa_group(60))
	end

	def pretty_print(board)
		e_size = 30 # augmentation size
		board.each_with_index do |row,c_dex|
			row.each_with_index do |c,r_dex|
				x,y = [r_dex,c_dex].map{|i|i*e_size+100}
				fill(c,100,100) ; ellipse(x,y,e_size,e_size)
			end
		end
	end

	def rsa_group(int)
		non_factors = (1...int).select{|i|i.gcd(int)==1}
		pairs = non_factors.inject([]){|is,i| is<<(non_factors).map{|j|i*j % int} }
 		# pairs.map{|p|puts "#{p}"}
	end

	def color_it(table)
		roots_color = (1..table.length).map{|n|360*n/(table.length)}
		apply_color = table.map do |k|
			keyed = k.zip(table[0]).sort
			keyed.zip(roots_color).sort_by{|i|i[0][1]}.map(&:last)
		end
	end

	def draw
		# rotateX(PI/3.0)
		pretty_print(@table)
	end
