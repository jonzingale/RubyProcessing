# Homology visualizer
SIMPLICES = (0..6).map{|s| eval("SIMPLEX_#{s} = (0..#{s}).to_a")}.freeze

def setup
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.5 ; size(1400,1000) #HOME

	@w,@h = [width,height].map{|i|i/5.0}
	stroke_width(3)
end

def abs(i) ; ((i**2)**0.5).to_i ; end
def is_compact?(simplex) ; del(del(simplex)).flatten.inject(0,:+) == 0 ; end

# 2-simplex
def split_simplex(simplex,line,p)
	faces = del(line.zip(simplex-line<<p).flatten)
	[faces[0],faces[2]]
end

def del(simplex)
	simplex[0].is_a?(Array) ? simplex.inject([]){|xs,s| xs + del(s) } :
	simplex.map.with_index{|s,i| simplex.reject{|x| x == s}.map{|j| j*(-1)**i } }
end

# 2-D simplices only
def add_p(simplex,line,p)
	edge = simplex - line << p
	del(simplex).inject([]) do |xs,s|
		cond = s.map{|j| abs(j) } == line
		cond ? xs + [[s[0], p],[p, s[1]]] : xs << s
	end + [edge, edge.map{|i|-i}]
end

# generalize to n-dimensions
def n_add_p(simplex,line,p)

end

def draw
	clear ; translate(@w,@h)
	n_add_p(SIMPLEX_3, SIMPLEX_3.take(2), 99)
end
