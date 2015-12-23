/* Example: bubble sort values in array */


#include <stdio.h>


void bubblesort_float_generic (float *x, int N, int (*compare_fn)(float*,float*) ) {
  float temp;
  int i, sorted;

  do {
       for (i = 1, sorted = 1; i < N; i++)
       {
         if ((*compare_fn)(&x[i-1], &x[i]))
         {
           sorted = 0;
           temp = x[i-1];
           x[i-1] = x[i];
           x[i] = temp;
         }
       }
     } while (!sorted);
}



int compare_floats_greater_than (float *x, float *y) {
  if ((*x) > (*y)) return 1;
  else return 0;
}


int compare_floats_less_than (float *x, float *y) {
  if ((*x) < (*y)) return 1;
  else return 0;
}




void print_float_array (char *message, float *x, int N) {
  int i;
  puts("\n");
  puts(message);
  for (i = 0; i < N; i++)
    printf("%8G  ", x[i]);
  puts("\n");
}



#define NUM 10 /* The number of values to be sorted */
float x[NUM] = { 1.0, 0.2, 0.5, 0.31, 1e10, 1e-10, 10, 20, -2, -10 };



main()
{

  print_float_array ("The original values are:", x, NUM);

  bubblesort_float_generic(x, NUM, &compare_floats_greater_than);
  print_float_array ("The sorted values are:", x, NUM);
  
  bubblesort_float_generic(x, NUM, &compare_floats_less_than);
  print_float_array ("The sorted values are:", x, NUM); 

}
