import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Main {

  private static final int THRESHOLD = 32;
  private static int[] ranks;

  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    for(;;) {
      int n = scanner.nextInt();
      if(n == 0) {
        scanner.close();
        return;
      }

      ranks = new int[n];
      List<Point> points = new LinkedList<Point>();
      for(int i = 0; i < n; i++)
        points.add(new Point(i, scanner.nextInt(), scanner.nextInt()));

      // Sort points from small to large
      Collections.sort(points, new Comparator<Point>() {
        @Override
        public int compare(Point p1, Point p2) {
          if(p1.x == p2.x)
            return Integer.compare(p1.y, p2.y);
          return Integer.compare(p1.x, p2.x);
        }
      });

      // Find rank recursively
      findRank(points);

      // Output the result
      System.out.print(ranks[0]);
      for(int i = 1; i < n; i++)
        System.out.print(" " + ranks[i]);
      System.out.println();
    }
  }

  private static List<Point> findRank(List<Point> points) {
    // If size of points is small enough, sort them by insertion sort, and update their ranks
    if(points.size() <= THRESHOLD) {
      for(int i=1, j; i<points.size(); i++) {
        Point temp = points.get(i);
        for(j=i-1; j>=0 && points.get(j).isGreater(temp); j--) {
          points.set(j+1, points.get(j));
        }
        ranks[temp.index] += j+1;
        points.set(j+1, temp);
      }

      return points;
    }

    List<Point> leftPoints = new LinkedList<Point>(points.subList(0, points.size() / 2));
    List<Point> rightPoints = new LinkedList<Point>(points.subList(points.size() / 2, points.size()));

    // Find rank recursively
    leftPoints = findRank(leftPoints);
    rightPoints = findRank(rightPoints);

    // Merge left and right parts of points, and calculate the ranks
    List<Point> result = new LinkedList<Point>();
    int leftCount = 0;
    while(!(leftPoints.isEmpty() || rightPoints.isEmpty())) {
      Point point;
      if(rightPoints.get(0).isGreater(leftPoints.get(0))) {
        point = leftPoints.remove(0);
        result.add(point);
        leftCount++;
      }
      else {
        point = rightPoints.remove(0);
        ranks[point.index] += leftCount;
        result.add(point);
      }
    }

    for (Point point : leftPoints) {
      result.add(point);
      leftCount++;
    }
    for (Point point : rightPoints) {
      ranks[point.index] += leftCount;
      result.add(point);
    }

    return result;
  }
}

class Point {
  int index;  // Record origin index
  int x;
  int y;

  public Point(int index, int x, int y) {
    this.index = index;
    this.x = x;
    this.y = y;
  }

  public boolean isGreater(Point anotherPoint) {
    return this.y >= anotherPoint.y;
  }
}
