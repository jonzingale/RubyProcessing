require 'jens_graph.rb'
include JensGraph

class Jens
	attr_reader :n, :value
	def initialize(n) ; @n = n ; end
	def value ; @value = @n % 10 ; end
	def input(n) ; @n = n ; end 

	def produce
		@n = @n == 1 ? 1 :
		@n.even? ? @n/2 :
		3 * @n + 1
		value
	end
end

def setup
	size(displayWidth/2, displayHeight/2)
	@w, @h = [width/2.0, height/2.0]
	colorMode(HSB,360,100,100,100)
  text_font create_font("SanSerif",30)
	background(0)
  frame_rate 1

  @jens = Jens.new(216)
end

def publish_jens
	if @jens.n > 1
		@jens.produce
		text("#{@jens.n}",100,100)
	else
		@jens.input(rand(216))
	end
end

def draw
	clear
	graph ; numbers
	publish_jens
end

