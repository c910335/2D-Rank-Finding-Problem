import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Scanner;

public class Main {

  static int[] ranks;

  public static void main(String[] args) {
    Scanner scn = new Scanner(System.in);

    while(true) {
      int n = scn.nextInt();
      if(n == 0) {
        scn.close();
        return;
      }

      ranks = new int[n];
      List<Point> points = new LinkedList<Point>();
      for(int i=0; i<n; i++) {
        int x = scn.nextInt();
        int y = scn.nextInt();
        points.add(new Point(i, x, y));
      }

      // Sort points from small to large
      Collections.sort(points, new Comparator<Point>() {
        @Override
        public int compare(Point p1, Point p2) {
          if(p1.x == p2.x) {
            return Integer.compare(p1.y, p2.y);
          }
          return Integer.compare(p1.x, p2.x);
        }
      });

      // Find rank recursively
      points = findRank(points);

      // Output the result
      System.out.print(ranks[0]);
      for(int i=1; i<n; i++) {
        System.out.print(" " + ranks[i]);
      }
      System.out.println();
    }
  }

  static List<Point> findRank(List<Point> points) {
    // Termination condition of the split
    if(points.size() <= 1) {
      return points;
    }

    List<Point> leftPoints = new LinkedList<Point>(points.subList(0, points.size()/2));
    List<Point> rightPoints = new LinkedList<Point>(points.subList(points.size()/2, points.size()));

    // Find rank recursively
    leftPoints = findRank(leftPoints);
    rightPoints = findRank(rightPoints);

    // Merge left and right parts of points, and calculate the ranks
    List<Point> result = new LinkedList<Point>();
    int leftCount = 0;
    while(!leftPoints.isEmpty() && !rightPoints.isEmpty()) {
      Point point;
      if(rightPoints.get(0).isGreater(leftPoints.get(0))) {
        point = leftPoints.remove(0);
        result.add(point);
        leftCount ++;
      }
      else {
        point = rightPoints.remove(0);
        ranks[point.index] += leftCount;
        result.add(point);
      }
    }

    for (Point point : leftPoints) {
      result.add(point);
      leftCount ++;
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