using System;
using System.Collections.Generic;
using System.Linq;

namespace csharp
{
    class Program
    {
        struct Point
        {
            public Point(int id, int x, int y)
            {
                Id = id;
                X = x;
                Y = y;
            }

            public int Id;
            public int X;
            public int Y;
        }

        static Point[] Data;
        static int[] Answer;
        const int Threshold = 33;

        static void FindRanks(int left, int right)
        {
            int i, j;
            if (right - left <= Threshold)
            {
                for (i = left + 1; i < right; ++i)
                {
                    Point tp = Data[i];
                    if (Data[i].Y < Data[left].Y)
                    {
                        Array.Copy(Data, left, Data, left + 1, i - left);
                        Data[left] = tp;
                        continue;
                    }
                    j = i - 1;
                    while (Data[i].Y < Data[j].Y)
                    {
                        --j;
                    }
                    Array.Copy(Data, j + 1, Data, j + 2, i - j - 1);
                    Data[j + 1] = tp;
                    Answer[tp.Id] += j - left + 1;
                }
                return ;
            }

            int mid = (left + right) / 2;
            FindRanks(left, mid);
            FindRanks(mid, right);

            j = 0;
            int k = mid, size = mid - left;
            Point []tdata =  new Point[size];
            Array.Copy(Data, left, tdata, 0, size);
            
            i = left;
            while (true)
            {
                if (tdata[j].Y <= Data[k].Y)
                {
                    Data[i] = tdata[j++];
                    if(j == size)
                    {
                        for (; k != right; ++k)
                        {
                            Answer[Data[k].Id] += j;
                        }
                        break;
                    }
                }
                else
                {
                    Data[i] = Data[k];
                    Answer[Data[k++].Id] += j;
                    if(k == right)
                    {
                        for (++i; i != right; ++i, ++j)
                        {
                            Data[i] = tdata[j];
                        }
                        break;
                    }
                }
                i++;
            }
        }

        static void Main(string[] args)
        {
            while(true)
            {
                int n = int.Parse(Console.ReadLine());
                
                if (n == 0)
                {
                    break;
                }
                else
                {
                    Data = new Point[n];
                    Answer = new int[n];
                }

                for (int i = 0; i < n; ++i)
                {
                    var line = Console.ReadLine();
                    var numbers_str = line.Split(' ');
                    int x = int.Parse(numbers_str[0]);
                    int y = int.Parse(numbers_str[1]);
                    Data[i] = new Point(i, x, y);
                    Answer[i] = 0;
                }
                
                Data = Data.OrderBy(d => d.X).ThenBy(d => d.Y).ToArray();
                    
                FindRanks(0, n);

                Console.WriteLine(String.Join(" ", Answer));
            }
        }
    }
}
