# Homology visualizer
SIMPLICES = (0..6).map{|s| eval("SIMPLEX_#{s} = (0..#{s}).to_a")}.freeze

def setup
	size(displayWidth/2, displayHeight/2)
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.5
	@w,@h = [width,height].map{|i|i/5.0}
	stroke_width(3)
end

def abs(i) ; ((i**2)**0.5).to_i ; end
def is_compact?(simplex) ; del(del(simplex)).flatten.inject(0,:+) == 0 ; end

def del(simplex)
	simplex[0].is_a?(Array) ? simplex.inject([]){|xs,s| xs + del(s) } :
	simplex.map.with_index{|s,i| simplex.reject{|x| x == s}.map{|j| j*(-1)**i } }
end

# if two edges have a common vertex
# name and cut, otherwise don't.
def split_triangle(e1,e2)
	if (sig = e1|e2).count == 3 ; hs = Hash.new
		(0..4).zip(sig+((0..4).to_a-sig)).each{|i,e| hs[i]=e}
		[[0,3,2],[3,4,2],[3,1,4]].map{|a| a.map{|i| hs[i]}}
	end
end

# if two edges have a common vertex
# name and cut, otherwise don't.
def split_triangle_2(e1,e2)
	if (sig = e1|e2).count == 3
		hs = Hash.new ; keys = %w(a b c d e)
		keys.zip(sig+['p','q']).each { |i,e| hs[i]=e }
		%w(adc dec dbe).map { |a| a.split('').map { |i| hs[i] } }
	end
end

def draw
	clear ; translate(@w,@h)
	
	split_triangle([0,1],[3,1])
end
