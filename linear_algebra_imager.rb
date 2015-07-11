require 'Matrix'
	# a place to put some linear_algebra ideas
	
	COORDS = [[255, 176], [337, 656], [951, 663]].freeze
	VECTS = COORDS.map{|v|Vector.elements(v)}.freeze

	def setup
		# size(1800,900) ; background(20) ; frame_rate 30 #JR
		size(1400,850) ; background(20) ; frame_rate 30
		@w, @h = [width,height].map{|i|i/2.0} ; @i = 0
  	@m = [235,18,85]
  	text_font create_font("SanSerif",25)
  	stroke(200,200,200)
  	colorMode(HSB,360,100,100)
	end

	def orth(vect) ; x,y = vect.to_a ; Vector.elements([y,-x]) ; end
	def trigs(theta) ; %w(cos sin).map{|s| eval("Math.#{s} #{theta}")} ; end
	def rootsUnity(numbre) ; (0...numbre).map{|i|trigs(i*2*PI/numbre)} ; end
	def avg_vs(vect,wect) ; (vect+wect)/2.0 ; end

	def inner(vect,wect)
		[vect,wect].map(&:to_a).transpose.map{|p| p.inject(1,:*)}.inject(0,:+)
	end

	def santa_fe
		range = ([[0,1],[1,2]]).each do |pair|
			quad = pair.map{|x| COORDS[x] }.flatten
			stroke(30,70,200,70) ; stroke_weight(2) ; line(*quad)
		end
	end

	def dinside(point)
		b, a, c = VECTS ; p = Vector.elements(point) - a

		cond1 = (b_part = inner(p, orth(b - a))) < 0
		cond2 = b_part * inner(p, orth(c - a)) < 0
		# cond2 = inner(p, avg_vs(b,c) - a) > 0

		cond1&&cond2 ? fill(rand(40)-10,100,100) : fill(200+rand(20),100,100)

		no_stroke ; ellipse(*point,12,10)
	end

	def draw
		santa_fe
		pt = [width,height].map{|s| rand(s) }
		dinside(pt)
	end