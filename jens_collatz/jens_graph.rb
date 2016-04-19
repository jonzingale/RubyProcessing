module JensGraph
	def numbers
		$app.text('3', @w+140,@h-140)
		$app.text('0', @w+290,@h-140)
		$app.text('5', @w+290,@h+10)
		$app.text('*', @w+70, @h+90)
		$app.text('7', @w+70, @h+230)
		$app.text('9', @w-110, @h-90)
		$app.text('6', @w-10, @h+10)
		$app.text('8', @w+140,@h+10)
		$app.text('4', @w-10, @h+160)
		$app.text('2', @w+140,@h+160)
	end

	def graph
		$app.stroke(234,100,100,100)
		$app.stroke_width(4) ; no_fill
		$app.rect(@w, @h, 150, 150)# 6842
		$app.rect(@w+150, @h-150, 150, 150)# 6305
		$app.line(@w,@h+150,@w+75,@h+75)# 14
		$app.line(@w+150,@h+150,@w+75,@h+75)	# 21
		$app.line(@w+150,@h+150,@w+75,@h+225) # 72
		$app.line(@w,@h+150,@w+75,@h+225) # 47
		$app.bezier(@w, @h, 300, 300, 200, 200, @w-100, @h-100)# 98
		$app.line(@w, @h, @w-100, @h-100)# 98
		$app.ellipse(@w+325, @h-168, 60, 60)# 0 loop
	end
end