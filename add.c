#include <stdio.h>
#include <sys/time.h>
#include <iostream>

using namespace std;

double get_time()
{  struct timeval tim;
   gettimeofday(&tim, NULL);
   return (double) tim.tv_sec+(tim.tv_usec/1000000.0);
}

//KERNEL
void Add(float *a, float *b, float *c, int N)
{
	for(int i=0;i<N;++i){
	c[i] = a[i] + b[i];
	}
}

int main()
{

//ALLOCATE AND INITIALIZE DATA ON CPU

printf("\n ALLOCATE AND INITIALIZE DATA ON CPU\n");
printf("----------------------------------------\n");

const int N = 8388608; 
float *a = new float[N];
float *b = new float[N];
float *c = new float[N];

for( int j=0;j<N;++j)
{
	a[j]=j;
	b[j]=j;
	c[j]=0;
}

printf("\n Vector A\n");
cout<<"A[0]="<<a[0]<<endl;
printf(".\n.\n.\n");
cout<<"A[N-1]="<<a[N-1]<<endl;

printf("\n Vector B\n");
cout<<"B[0]="<<b[0]<<endl;
printf(".\n.\n.\n");
cout<<"B[N-1]="<<b[N-1]<<endl;

//RUN KERNEL
printf("\n RUN KERNEL\n");
printf("----------------------------------------");

double start = get_time(); //Initial time
Add(a, b, c, N);
double finish = get_time(); //Final time

double diff = finish - start;
cout<<"\nTotal time ="<<diff<<" [s]\n"<<endl;


cout<<"\na[N-1] + b[N-1] ="<<a[N-1]<<"+"<<b[N-1]<<endl;
cout<<"C[N-1] = "<<c[N-1]<<endl;


return 0;
}
