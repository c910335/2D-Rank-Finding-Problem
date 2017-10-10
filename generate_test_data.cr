module PHW1
  class_getter random = Random.new

  def self.max_xy(n)
    return 256_i64 if n < 100
    return 65536_i64 if n < 10000
    return 2147483648_i64
  end

  def self.print_test_case(n, limit)
    puts n
    pm = Set(Tuple(Int64,Int64)).new
    while n > 0
      xy = {random.rand((-limit)...limit), random.rand((-limit)...limit)}
      next if pm.includes? xy
      puts xy.join(' ')
      pm << xy
      n -= 1
    end
  end
end

n = 5
while n <= 100000
  PHW1.print_test_case n, PHW1.max_xy(n)
  n += PHW1.random.rand(n)
end
PHW1.print_test_case 100000, 2147483648_i64
puts 0
