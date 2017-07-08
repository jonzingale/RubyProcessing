# This ruby-processing file generates the group
# multiplication table for a group of units of n,
# given an integer n.

	# rsa groups with holes for unit
	Prod_of_2s = [10, 14, 22, 26, 34, 38, 9, 15, 21, 33, 39, 51, 57, 25, 35, 55, 65, 85, 95, 49, 77, 91, 119, 133, 121, 143, 187, 209, 169, 221, 247, 289, 323, 361]
	# Prod_of_2s = [22, 35, 29,57,22,51,34]

	def setup
		background(0)
		# zahlen = (2*3*5*7)-1# <-- change integer here. # what is biggest array?
		# @table = color_it(rsa_group(zahlen))
		square = [1000] * 2 ; size(*square)
		frame_rate 0.2 ; colorMode(HSB,360,100,100)
	end

	def pretty_print(board)
		scale = width/board[0].length*0.9
		board.each_with_index do |row,c_dex|
			row.each_with_index do |c,r_dex|
				x,y = [r_dex,c_dex].map{|i|i*scale+50}
				c==0 ? fill(200,80,100)  : fill(10,100,30) #c

				# fill(c,100,100) ; 
				ellipse(x,y,scale,scale)
			end
		end
	end

	def rsa_group(int)
		non_factors = (1...int).select{|i|i.gcd(int)==1}
		non_factors.inject([]){|is,i| is << (non_factors).map{|j| i*j%int} }
	end

	def color_it(table)
		roots_color = (0...table.length).map{|n|360*n/(table.length)}
		apply_color = table.map do |k|
			keyed = k.zip(table[0]).sort.zip(roots_color)
			keyed.sort_by{|i|i[0][1]}.map(&:last)
		end
	end

	def draw
		# clear # 22, 35, 29,57,22,51
		zahlen = 323#Prod_of_2s[rand 34]
		@table = color_it(rsa_group(zahlen))
		pretty_print(@table)
		# text("#{zahlen}",10,10)
	end


