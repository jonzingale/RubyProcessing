class Fractal
  attr_accessor :max_iterations, :limit
  def initialize (options={}, &block)
    @max_iterations = options[:max_iterations] || 100
    @limit = options[:limit] || 1_000_000

    self.class.send(:define_method, :iterate, &block)
  end

  def escape_iterations(c)
    n = Complex(0, 0)
    max_iterations.times do |i|
      n = iterate(n, c)
      return i if escaped?(n)
    end
    return nil
  end

  def escaped?(n)
    ((n.real * n.real) + (n.imag * n.imag)) > limit
  end
end
