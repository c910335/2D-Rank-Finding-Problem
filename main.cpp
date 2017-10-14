#include <algorithm>
#include <iostream>
#define THRESHOLD 60

using std::cin;
using std::cout;
using std::endl;
using std::sort;
using std::copy_backward;

class point {
public:
  int i, x, y;
};

bool cmp(point a, point b) {
  if (a.x == b.x)
    return a.y < b.y;
  return a.x < b.x;
}

int n, ranks[100000];
point ps[100000];

void find_ranks(int first, int last) {
  if (last - first <= THRESHOLD) {
    int i, j;
    point tp;
    for (i = first + 1; i < last; ++i) {
      tp = ps[i];
      if (ps[i].y < ps[first].y) {
        copy_backward(ps + first, ps + i, ps + i + 1);
        ps[first] = tp;
        continue;
      }
      for (j = i - 1;; --j)
        if (ps[i].y >= ps[j].y)
          break;
      copy_backward(ps + j + 1, ps + i, ps + i + 1);
      ps[j + 1] = tp;
      ranks[tp.i] += j - first + 1;
    }
    return;
  }

  int mid = (first + last) / 2;
  find_ranks(first, mid);
  find_ranks(mid, last);

  int i, j = 0, k = mid, size = mid - first;
  point *tps = new point[size];
  for (i = 0; i != size; ++i)
    tps[i] = ps[i + first];
  
  for(i = first;; ++i) {
    if (tps[j].y <= ps[k].y) {
      ps[i] = tps[j++];
      if (j == size) {
        for (; k != last; ++k)
          ranks[ps[k].i] += j;
        break;
      }
    } else {
      ps[i] = ps[k];
      ranks[ps[k].i] += j;
      k++;
      if (k == last) {
        for (++i; i != last; ++i, ++j)
          ps[i] = tps[j];
        break;
      }
    }
  }
  delete[] tps;
}

int main() {
  std::ios_base::sync_with_stdio(false);
  for(;;) {
    cin >> n;
    if (n == 0)
      return 0;

    int i;
    for (i = 0; i != n; ++i) {
      cin >> ps[i].x >> ps[i].y;
      ps[i].i = i;
      ranks[i] = 0;
    }

    sort(ps, ps + n, cmp);

    find_ranks(0, n);

    cout << ranks[0];
    for (i = 1; i != n; ++i)
      cout << ' ' << ranks[i];
    cout << endl;
  }
}
