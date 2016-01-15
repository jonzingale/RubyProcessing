# P-adic visualizer
# p_ord  :: prime -> Z* -> N
# p_norm :: prime -> Z* -> Q
# p_dist :: prime -> Z* -> Z* -> Q

# triangles?
# lattice :: N -> IO(lattice)
# what can be learned from looking at ||p over all p?

# cauchy sequences

require 'matrix'
ID = Matrix.columns([[1,0],[0,1]])
def setup
	text_font create_font("SanSerif",40)
  background(20) ; frame_rate 0.5 ; size(1400,1000) #HOME

	@w,@h = [width,height].map{|i|i/5.0}
	stroke_width(3)
end

def n_ary(n=2,x=0,ary=[])
	x==0 ? [0,0].drop(ary.count)+ary : n_ary(n,x/n,ary.unshift(x%n))
end

def primes(i=2,ps=[2])
  ps.none?{|p|i % p == 0 } ? primes(i+=1,ps<<i) : primes(i+=1,ps)
end


# log like ord:
# ord(a+b) = min(ord a, ord b)
# ord(a*b) = ord a + ord b
# ord(a**b) = b(ord a)

# distance: d(a,b) = |b-a|

def all_vs(p=2) ; (0...p**2).map{|x|Vector.elements(n_ary(p,x))} ; end
def vect_product(p=2) ; all_vs(p).product(all_vs(p)).map{|vs|Matrix.rows(vs)} ; end

def p_ord(prime=2,n=1,a=0) ; a += 1 while n % prime ** a == 0 ; a-1 ; end
def p_norm(prime=2,x=2) ; x == 0 ? 0 : [1,prime ** ord(prime,x)] ; end
def p_dist(prime=2,x=2,y=2) ; p_norm(prime,y-x) ; end

def draw
	clear ; translate(@w,@h)

end
