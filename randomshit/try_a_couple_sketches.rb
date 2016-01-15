THEM = ['Bubbles.rb','blinky_processing.rb','ChaseIsON.rb','christmas.rb','ChaseIsON2.rb','color_sampler.rb','ChaseIsON3.rb','crazy_straws.rb','Chudnovsky.rb','ColorCube.rb','flowers_both.rb','Drawing.rb','goblet.rb','Drawing2.rb','homology.rb','hsb_sphere.rb','hsb_sphere2.rb','GoodVibe.rb','hyper_cube.rb','HappyBirthdaySteve.rb','hyper_cube_2.rb','Jakes_Spiral.rb','hyper_cube_sarah.rb','Jakes_Spiral2.rb','hyper_cube_sarah_2.rb','hyper_cube_sarah_3.rb','SteadyState.rb','p_adic.rb','TestDraw.rb','pi_day_2015.rb','YouWantASpiral.rb','pure_sarah.rb','active_record_visualizer.rb','rsa_count_up.rb','active_record_visualizer_scraper.rb','rsa_groups.rb','active_record_visualizer_test.rb','active_record_visualizer_test2.rb','sarah_groups.rb','all_sun.rb','sarahs_rsa.rb','all_sun_blur_rug.rb','spiral_awesomeness.rb','bezier_studies.rb','sun_and_lightning.rb','bezier_studies2.rb','tesseract.rb','big_time_trannies.rb','tesseract_2.rb','big_time_trannies2.rb','tesseract_3.rb','big_time_trannies3.rb','tesseract_4.rb','blinky.rb','tesseract_it.rb','blinky_flowers.rb','blinky_grasses.rb','test_ruby.rb','blinky_lights.rb','using_get_to_update.rb','blinky_mosaic.rb','white_robe.rb'].freeze
THEM.each{|file| %x(rp5 run #{file})}


	def setup
		text_font create_font("SanSerif",10);
		# size(1920,1080) #JackRabbit
		square = [1080] * 2  + [P3D] # 800
		@w,@h = [square[0]/2] * 2
		size(*square) ; @bs = [height,width].min
		@i, @t = [0] * 2 ; background(0)
		@colors = (0..3).map{|i|rand(255)}
		frame_rate 50 ; colorMode(HSB,360,100,100)
		no_fill() ; lights() ; no_stroke
	end

	def text_block(string='')
		fill(0,0,0) ; no_stroke
		rect(@w-40,@h-40,@w+40,@h+40)
		fill(200, 140, 0)
		text(string,@w,@h)
	end

	def draw
		omega = 360 * 5 ; r = 360
		@i = (@i+1) % omega
		x,y = %w(sin cos).map{|s| Math.send(s, 2*PI*@i/360) }
		# fill(@i%360,100,100) ; ellipse(r*x+@w,r*y+@h,10,10)

		fill(@i%360,100,100-(@i/(3.6*5)))
		ellipse((r-@i/5.0)*x+@w,(r-@i/5.0)*y+@h,30,30)
		# set((r-@i/2.0)*x+@w,(r-@i/2.0)*y+@h,color(@i%360,100,100))

		# @t += 1
		# if @t == 2000 # better would be radius
		# 	%x(rp5 run pure_sarah.rb)
	end
