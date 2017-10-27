package main

import(
    "fmt"
    "bufio"
    "os"
    "strconv"
    "sort"
)


type Point struct {
    i, x, y int
}

var rank []int

func findRank(p []Point) []Point{
    if len(p) <= 1 {
        return p
    }
    var ret []Point
    i, li, ri := 0, 0, 0
    l := findRank(p[:int(len(p)/2)])
    r := findRank(p[int(len(p)/2):])
    ret = make([]Point, len(p))
    for {
        if l[li].y <= r[ri].y {
            ret[i] = l[li]
            li++
            if li >= len(l) {
                for _, v := range r[ri:] {
                    rank[v.i] += li
                    ret[i+1] = v
                    i++
                }
                break
            }
        } else {
            ret[i] = r[ri]
            rank[r[ri].i] += li
            ri++
            if ri >= len(r) {
                copy(ret[i+1:], l[li:])
                break
            }
        }
        i++
    }
    copy(p, ret)
    return p
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    scanner.Split(bufio.ScanWords)
    out := bufio.NewWriter(os.Stdout)
    defer out.Flush()
    for scanner.Scan() {
        n, _ := strconv.Atoi(scanner.Text())
        if n == 0 {
            break
        }
        var point []Point
        rank = make([]int, n)
        for i := 0; i < n; i++ {
            scanner.Scan()
            x, _ := strconv.Atoi(scanner.Text())
            scanner.Scan()
            y, _ := strconv.Atoi(scanner.Text())
            point = append(point, Point{i, x, y})
        }
        sort.Slice(point, func(i, j int) bool {
            if point[i].x != point[j].x {
                return point[i].x < point[j].x
            } else {
                return point[i].y < point[j].y
            }
        })
        findRank(point)
        fmt.Fprintf(out, "%d",rank[0])
        for i := 1; i < len(rank); i++ {
            fmt.Fprintf(out, " %d", rank[i])
        }
        fmt.Fprintf(out, "\n")
    }
}
