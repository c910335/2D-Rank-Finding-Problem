// ConsoleApplication2.cpp: 定义控制台应用程序的入口点。
//

#include<iostream>
#include<algorithm>
using namespace std;

class Point {
public:
	Point() {
		x = y = rank = 0;
	}
public:
	char direction;
	int x;
	int y;
	int idx;
	int rank;
};
bool dominate(Point p1, Point p2) {
	if (p1.x > p2.x && p1.y > p2.y) {
		return true;
	}
	else {
		return false;
	}
}

bool cmp1(Point p1, Point p2) {
	if (p1.x>p2.x)
		return false;
	else
		return true;
}

bool cmp2(Point p1, Point p2) {
	if (p1.y>=p2.y)
		return false;
	else
		return true;
}

bool idxcmp(Point p1, Point p2) {
	if (p1.idx < p2.idx)
		return true;
	else
		return false;
}
void rank_finding1(Point p[],int l, int r) {
	for (int i = l;i<r;i++) {
		for (int j = l;j<r;j++) {
			if (dominate(p[i], p[j])) {
				p[i].rank++;
			}
		}
	}
}

void devide(Point p[20], int l, int r) {
	if(r-l > 1){
		double sum = 0;	
		int c = 0;
		int mid = (r + l) / 2;
		int ave = p[mid].x;
		devide(p, l, mid);
		devide(p, mid, r);

		for (int i = l;i < r;i++) {
	
			if (p[i].x < ave) {
				p[i].direction = 'l';
			}
			else {
				p[i].direction = 'r';
			}
		}
		sort(p + l, p + r, cmp2);
		int cnt = 0;
		for (int i = l;i < r;i++) {
			if (p[i].direction == 'l')
				cnt++;
			else {
				p[i].rank += cnt;
			}
		}
	}
	else {
		return;
	}
}

void rank_finding2(Point p[], int n) {
	sort(p, p + n,cmp1);
	devide(p,0,n);
	sort(p, p + n, idxcmp);
}

int main() {

	int n;
	Point p[20];
	while (cin >> n && n != 0) {
		for (int i = 0;i<n;i++) {
			cin >> p[i].x;
			cin >> p[i].y;
			p[i].idx = i;
			p[i].rank = 0;
		}

		//rank_finding1(p, n); brute froce compare

		//devide & conquer
		rank_finding2(p, n);

		for (int i = 0;i<n;i++) {
			cout << p[i].rank << " ";
		}
		cout << endl;
	}
}

/*
input
5
1 4
6 2
8 0
2 7
7 5
7
1 2
-3 -4
5 6
-7 -8
3 7
-5 -9
0 0
0
*/

/*
output
0 0 0 1 2
4 2 5 0 5 0 3
*/

