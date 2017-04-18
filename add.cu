#include <iostream>
#include <stdio.h>
#include <sys/time.h>

using namespace std;

double get_time()
{  struct timeval tim;
   gettimeofday(&tim, NULL);
   return (double) tim.tv_sec+(tim.tv_usec/1000000.0);
}

//KERNEL
__global__ void Add(float *a, float *b, float *c, int N, int BSZ)
{

	int i = blockIdx.x*BSZ + threadIdx.x;

	for(i=0;i<N;i++)
	{
	c[i] = a[i] + b[i];
	}

}

int main()
{

//ALLOCATE AND INITIALIZE DATA ON CPU

printf("\n ALLOCATE AND INITIALIZE DATA ON CPU\n");
printf("----------------------------------------\n");
int N =1048576; //n° of threads
cout<<"N° of threads="<<N<<endl;
int blocksize = 256;
cout<<"N° of threads per block="<<blocksize<<endl;
int num_block = (N-0.5)/blocksize + 1;
cout<<"N° of blocks="<<num_block<<endl;

//float *a, *b, *c;
//a = (float *)malloc(N*sizeof(float));

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

//ALLOCATE DATA ON GPU
printf("\n ALLOCATE DATA ON GPU\n");
printf("----------------------------------------");

float *d_a, *d_b, *d_c;

cudaMalloc((void**) &d_a, N*sizeof(float));
cudaMalloc((void**) &d_b, N*sizeof(float));
cudaMalloc((void**) &d_c, N*sizeof(float));

//cudaMalloc(&d_a, N*sizeof(float));

//TRANSFER DATA FROM CPU TO GPU
printf("\n TRANSFER DATA FROM CPU TO GPU\n");
printf("----------------------------------------");

cudaMemcpy(d_a, a, N*sizeof(float), cudaMemcpyHostToDevice);
cudaMemcpy(d_b, b, N*sizeof(float), cudaMemcpyHostToDevice);
cudaMemcpy(d_c, c, N*sizeof(float), cudaMemcpyHostToDevice);

//RUN KERNEL
printf("\n RUN KERNEL\n");
printf("----------------------------------------");

double start = get_time(); //Initial time
Add<<<num_block,blocksize>>>(d_a, d_b, d_c, N, blocksize);
double finish = get_time(); //Final time

double diff = finish - start;
cout<<"\nTotal time ="<<diff<<" [s]\n"<<endl;

//TRANSFER DATA FROM GPU TO CPU
printf("\n TRANSFER DATA FROM GPU TO CPU\n");
printf("----------------------------------------");

cudaMemcpy(c, d_c, N*sizeof(float), cudaMemcpyDeviceToHost);

cout<<"\na[N-1] + b[N-1] ="<<a[N-1]<<"+"<<b[N-1]<<endl;
cout<<"C[N-1] = "<<c[N-1]<<endl;

//FREE MEMORY
cudaFree(d_a);
cudaFree(d_b);
cudaFree(d_c);

return 0;
}
