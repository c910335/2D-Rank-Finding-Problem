THRESHOLD = 20

class Point
  attr_accessor :i, :x, :y
end

def find_ranks ps
  if ps.size <= THRESHOLD
    (1...ps.size).each do |i|
      tp = ps.delete_at(i)
      if tp.y < ps[0].y
        ps.unshift(tp)
        next
      end
      j = i
      loop do
        break if tp.y >= ps[j - 1].y
        j -= 1
      end
      ps.insert(j, tp)
      $ranks[tp.i] += j
    end
    return ps
  end

  mid = ps.size / 2
  left = find_ranks(ps[0...mid])
  right = find_ranks(ps[mid..-1])
  ps = []

  count = 0
  loop do
    if left.first.y <= right.first.y
      ps << left.shift
      count += 1
      if left.empty?
        right.each do |p|
          $ranks[p.i] += count
        end
        ps += right
        break
      end
    else
      $ranks[right.first.i] += count
      ps << right.shift
      if right.empty?
        ps += left
        break
      end
    end
  end
  return ps
end

loop do
  n = gets.chomp.to_i
  break if n == 0

  ps = Array.new(n) { Point.new }
  $ranks = [0] * n
  n.times do |i|
    ps[i].i, ps[i].x, ps[i].y = [i] + gets.chomp.split.map(&:to_i)
  end

  ps.sort! do |a, b|
    next a.y <=> b.y if a.x == b.x
    a.x <=> b.x
  end

  find_ranks(ps)

  puts $ranks.join(' ')
end
