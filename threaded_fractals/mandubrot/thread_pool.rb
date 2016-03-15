class ThreadPool
  attr_reader :num_threads

  def initialize(n, &block)
    @num_threads = n
    @threads = []
    @queue = Queue.new
    @semaphore = Mutex.new
    @work = []

    num_threads.times do
      @threads << Thread.new do
        block.call(@queue.pop) while true
      end
    end
  end

  def set_work(w)
    @work = w
  end

  def start_work
    stop_work
    @work.each { |w| @queue << w }
  end

  def stop_work
    @queue.clear
  end

  def queue_size
    @queue.size
  end

  def synchronize
    @semaphore.synchronize do
      yield
    end
  end
end