local Point = {}
Point.__index = Point
Point.__lt = function(a, b)
  if a.x == b.x then
    return a.y < b.y
  end
  return a.x < b.x
end

function Point:new(x, y, idx)
  return setmetatable({ x = x, y = y, idx = idx }, Point)
end

while true do
  local ranks = {}

  function find_ranks(pts)
    local sz = #pts
    local l_sz = math.floor(sz / 2)
    local r_sz = sz - l_sz

    if sz == 1 then
      return pts
    end

    local pts_l = find_ranks(table.pack(table.unpack(pts, 1, l_sz)))
    local pts_r = find_ranks(table.pack(table.unpack(pts, l_sz + 1)))
    local res = {}
    local i, j = 1, 1

    while true do
      if pts_l[i].y <= pts_r[j].y then
        table.insert(res, pts_l[i])
        i = i + 1
        if i > l_sz then
          while j <= r_sz do
            ranks[pts_r[j].idx] = ranks[pts_r[j].idx] + i - 1
            table.insert(res, pts_r[j])
            j = j + 1
          end
          break
        end
      else
        table.insert(res, pts_r[j])
        ranks[pts_r[j].idx] = ranks[pts_r[j].idx] + i - 1
        j = j + 1
        if j > r_sz then
          table.move(pts_l, i, l_sz, #res + 1, res)
          break
        end
      end
    end

    return res
  end

  local pts = {}
  local n = io.read("*n")
  if n == 0 then
    break
  end

  for i = 1, n do
    x, y = io.read("*n", "*n")
    pts[i] = Point:new(x, y, i)
    ranks[i] = 0
  end

  table.sort(pts, cmp)
  find_ranks(pts)
  print(table.concat(ranks, ' '))
end
