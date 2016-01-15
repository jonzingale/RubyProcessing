# Triangles gone wild

def setup
	text_font create_font("SanSerif",60);
	background(10)
	size(1400,800); #width,height
  # color_mode RGB, 1.0
  frame_rate 22
  fill 2.8, 2.6
  smooth
  dex = 1
end

def draw
it = rand(25)
a,b,c,d,e,f = (1..6).map{|i| (it**i) % 3 }

(1..10).map do |i|
	t = [27,61,3,8,56,2,45,1].shuffle
	fill(color(rand(2)*t[1],rand(t[2])+100,rand(55)))
	bezier(80*i+(width/2), 200*rand(i^i),81,81,89, 89, 15, 80)
	# fill(color(rand(255)%it,rand(25)+1,rand(55)+200))
	
	i = 0
	(1..8).each do |e| ## big blue stuff
		i += 1
		i = 0 if i%100==0
	fill(color(rand(i+t[4]+t[2]),rand(25)+100,rand(55)+100))
end

	(1..8).each do |e| # crazy green dude
		i += 1
		i = 0 if i%300==0
		bezier(8*i, (8*rand(e)),(height/2)+81*t[0]%40,81+t[2],890, 890, 815, 880)
	end 	

	fill(color(rand(255),rand(25)+100,rand(55)+100))
	ellipse(30+(width/2),((a+30+b**2)**c % 400)+(height/2),20+rand(100),20)
end


fill(color(rand(25)+0,rand(25)+100,rand(55)+100))
ellipse(rand(width),rand(height),rand(width)/60,rand(height)/60)
end