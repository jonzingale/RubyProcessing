# Happy Pi day
def setup
	text_font create_font("SanSerif",60);
	background(10) ; size(850,850)
  frame_rate 100
  no_fill ; stroke(0,170,105)
  ellipse(0,0,width*2,width*2)
  @t=0 ; @i = 0
  noSmooth
end

def draw
	w,h = [width/2,height/2]
	x,y = (0..1).map{rand} ; 	@i += 1
	dist = Math.sqrt([x,y].inject(0){|t,i|t+i**2})

	dist <= 1 ? (@t += 1 ; stroke(0,200,200)) : stroke(200,200,0)
	ratio = (4.0*@t.to_f)/(@i.to_f)
	point(x*width,y*width)

	# text block
	fill(0,0,0) ; no_stroke
	rect(width-w*0.5,height-60,width,height)
	fill(200, 140, 0);
	text(ratio,width-0.5*w,height)
end
