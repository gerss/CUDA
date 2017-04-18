#include <iostream>
#include <sys/time.h>

using namespace std;

double get_time()
{  struct timeval tim;
   gettimeofday(&tim, NULL);
   return (double) tim.tv_sec+(tim.tv_usec/1000000.0);
}

//KERNEL
__global__ void Add(int *a, int *b)
{
a[0] += b[0];
}

int main()
{

//ALLOCATE AND INITIALIZA DATA ON CPU
int a = 5, b = 9;
int *d_a, *d_b;

//ALLOCATE DATA ON GPU
cudaMalloc(&d_a, sizeof(int));
cudaMalloc(&d_b, sizeof(int));

//TRANSFER DATA FROM CPU TO GPU
cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

double start = get_time(); //Initial time
//RUN KERNEL
Add<<<1,1>>>(d_a, d_b);
double finish = get_time(); //Final time

double diff = finish - start;
cout<<"time ="<<diff<<endl;

//TRANSFER DATA FROM GPU TO CPU
cudaMemcpy(&a, d_a, sizeof(int), cudaMemcpyDeviceToHost);

cout<<"Total time is : "<<a<<endl;

//FREE MEMORY
cudaFree(d_a);
cudaFree(d_b);

return 0;
}
