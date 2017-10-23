THRESHOLD = 23

module Answer
  class_property! ranks : Array(Int32)
end

class Point
  property! i : Int32, x : Int32, y : Int32
end

def find_ranks(ps : Array(Point), first : Int32, last : Int32)
  if last - first <= THRESHOLD
    ((first + 1)...last).each do |i|
      tp = ps[i]
      if ps[i].y < ps[first].y
        ps[(first + 1)..i] = ps[first...i]
        ps[first] = tp
        next
      end
      j = i
      loop do
        break if ps[i].y >= ps[j - 1].y
        j -= 1
      end
      if j < i
        ps[(j + 1)..i] = ps[j...i]
        ps[j] = tp
      end
      Answer.ranks[tp.i] += j - first
    end
    return
  end

  mid = (first + last) / 2
  find_ranks(ps, first, mid)
  find_ranks(ps, mid, last)

  tps, i, j, k = ps[first...mid], first, 0, mid
  loop do
    if tps[j].y <= ps[k].y
      ps[i] = tps[j]
      j += 1
      if j >= tps.size
        ps[k...last].each do |p|
          Answer.ranks[p.i] += j
        end
        break
      end
    else
      ps[i] = ps[k]
      Answer.ranks[ps[k].i] += j
      k += 1
      if k >= last
        ps[(i + 1)...last] = tps[j..-1]
        break
      end
    end
    i += 1
  end
end

loop do
  n = gets.to_s.chomp.to_i
  break if n == 0

  ps = Array(Point).new(n) { Point.new }
  Answer.ranks = [0] * n
  n.times do |i|
    ps[i].i, ps[i].x, ps[i].y = [i] + gets.to_s.chomp.split.map(&.to_i)
  end

  ps.sort! do |a, b|
    next a.y <=> b.y if a.x == b.x
    a.x <=> b.x
  end

  find_ranks(ps, 0, n)

  puts Answer.ranks.join(' ')
end
