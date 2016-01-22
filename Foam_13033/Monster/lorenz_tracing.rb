# Should likely be it's own object that can be called from LIVE:

require (File.expand_path('./bezier', File.dirname(__FILE__)))
require (File.expand_path('./monster', File.dirname(__FILE__)))
	def setup
		size(displayWidth, displayHeight)
		colorMode(HSB,360,100,100,60)
		@w, @h = [width/2.0, height/2.0]
		@i = 0 ; @t = 0
    frame_rate 10
		background(0)

		@monster = Monster.new width/2, height/2, 1
		stroke_width(@monster.thickness)
	end

	def draw
		@monster.dynamics
		# text("#{@monster.beziers.count}",100,199)

		(0..40).each do |q|
			@monster.beziers.each do |bezier|
				pt = bezier.plot(q / 40)
				qt = bezier.plot((q+1) / 40)
				color = [200+rand(100), 30+rand(50), 80, 100]
				stroke(*color) ; line(*pt,*qt)
			end
		end
	end