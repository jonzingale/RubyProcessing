require 'matrix'
require 'cmath'
require 'byebug'
include CMath

def cent_rand ; 100 * (rand - 1 * rand) ; end

def points num
	Matrix.build(num, 3) {|row, col| Complex(cent_rand, cent_rand) }
end

it = points(3)
that = Complex(23,2)





byebug ; 32