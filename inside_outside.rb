require 'Matrix'
	# find the inside versus the outside.
	# COORDS = [[255, 176], [337, 656], [951, 663]].freeze # for the fe
	COORDS = (0..2).map{[rand(1400),rand(850)]}.freeze

	# b <- a -> c
	VECTS = COORDS.map{|v|Vector.elements(v)}.freeze	
	REGION = ([[1,0],[1,2]]).map{|pair| pair.map{|x| COORDS[x] }.flatten}.freeze

	def setup
		# size(1800,900) ; background(20) ; frame_rate 30 #JR
		size(1400,850) ; background(20) ; frame_rate 30
		colorMode(HSB,360,100,100) ; text_font create_font("SanSerif",35) 
  	stroke(30,70,200,70) ; stroke_weight(2)
  	COORDS.zip(%w(b a c)).each{|c,l| text(l,*c)}
	end

	# orth in a counter-clockwise sense.
	def orth(vect) ; x,y = vect.to_a ; Vector.elements([-y,x]) ; end
	def draw ; santa_fe ; inside?([rand(width), rand(height)]) ; end
	def santa_fe ; REGION.each{ |quad| line(*quad) } ; end

	def inner(vect,wect)
		[vect,wect].map(&:to_a).transpose.map{|p| p.inject(1,:*)}.inject(0,:+)
	end

	def inside?(point)
		b, a, c = VECTS ; pt = Vector.elements(point) - a

		# perpendiculars have opposite signs.
		acute_cond =  inner(b - a, orth(a - c)) > 0
		_B = inner(pt, orth(b - a)) > 0
		_C = inner(pt, orth(a - c)) > 0
		cond = acute_cond ? _B & _C : _B | _C

		# name the angle obtuse or acute
		angle_type = acute_cond ? 'acute' : 'obtuse'
		text(angle_type,400,200)

		# color a location red or blue
		cond ? fill(rand(40)-10,100,100,90) : fill(200+rand(20),100,100,90)
		ellipse(*point,32,30)
	end