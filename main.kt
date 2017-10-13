import java.util.Scanner

const val THRESHOLD = 60

fun main(args: Array<String>) {
	val reader = Scanner(System.`in`)

	while (true) {
		val n: Int = reader.nextInt()
		if (n == 0) break

		var ranks = IntArray(n)
		var points = ArrayList<Point>()
		repeat(n) { i ->
			points.add(Point(i, reader.nextInt(), reader.nextInt()))
		}

		points.sort()

		findRank(ranks, points)

		println(ranks.joinToString(separator = " "))
	}

	reader.close()
}

fun <T> MutableList<T>.insertFrom(index: Int, to: Int) {
	if (index == to) return
	val tmp = this[index]
	this.removeAt(index)
	this.add(if (index > to) to else to - 1, tmp)
}

fun findRank(ranks: IntArray, points: MutableList<Point>) : List<Point> {
	if (points.size <= 1) return points
	if (points.size <= THRESHOLD) {
		repeat(points.size) {
			if (it == 0) return@repeat

			val currentPoint = points[it]
			if (currentPoint.y < points[0].y) {
				points.insertFrom(it, to = 0)
				return@repeat
			}

			var i = it
			while (true) {
				if (currentPoint.y >= points[i - 1].y) break;
				--i
			}
			points.insertFrom(it, to = i)
			ranks[currentPoint.i] += i
		}
		return ArrayList<Point>(points)
	}

	val leftPoints = findRank(ranks, points.subList(0, points.size / 2))
	val rightPoints = findRank(ranks, points.subList(points.size / 2, points.size))
	var resultPoints = ArrayList<Point>()

	var l: Int = 0
	var r: Int = 0
	while (true) {
		if (leftPoints[l].y <= rightPoints[r].y) {
			resultPoints.add(leftPoints[l++])
			if (l == leftPoints.size) {
				rightPoints.listIterator(r).forEach {
					ranks[it.i] += l
					resultPoints.add(it)
				}
				break
			}
		} else {
			resultPoints.add(rightPoints[r])
			ranks[rightPoints[r++].i] += l
			if (r == rightPoints.size) {
				resultPoints.addAll(leftPoints.subList(l, leftPoints.size))
				break
			}
		}
	}

	return resultPoints
}

data class Point(val i: Int, val x: Int = 0, val y: Int = 0) : Comparable<Point> {
	override fun compareTo(other: Point) : Int = if (this.x == other.x) this.y.compareTo(other.y) else this.x.compareTo(other.x)
}
