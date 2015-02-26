#!/usr/bin/env ruby
require 'activesupport'
require 'byebug'
require 'ruby-processing'

class Sketch < Processing::App
	def setup
	size(500, 500)
	fill(102);
	text_font create_font("SanSerif",30);
	end
	
	def draw
	fill 123;
	text "Hello World",5,30;
	
	line(0,500,500,0);
	fill(255);
	
	noFill();
	stroke(255, 102, 0);
	bezier(0, 500, 250, 0,250, 0,500, 500);
	
	line(0,0,120,120)
	stroke(120%256)
	
	ellipse mouse_x, mouse_y, 100, 100
	end
end