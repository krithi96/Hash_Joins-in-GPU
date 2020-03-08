
#include<stdio.h>
#include <curand_kernel.h>


#define p 334214459
#define TABLESIZE 250
#define maxiterations 10
#define KEYEMPTY -1

__device__ 
unsigned long long  table[TABLESIZE];



__device__
unsigned long long make_entry(unsigned long key, unsigned long value){
  //printf("key : %d, value : %d",key , value);
  unsigned long long ans = (key<<32)+value;
  //printf ("ans : %d ", (int)ans>>32);
  printf("\n");
  return ans;
}

__device__ unsigned getkey(unsigned long long entry){
return (entry)>>32;
}

__device__
unsigned hash_function_1(unsigned key){
   int a1 = 5;
   int b1 = 2;
   return (((a1*key+b1)%p)%TABLESIZE);
}

__device__
unsigned hash_function_2(unsigned key){
   int a1 = 13;
   int b1 = 7;
   return (((a1*key+b1)%p)%TABLESIZE);
}


__global__
void hash_join(int *Table_A,int *Table_B, int width, int height){

  int index = blockIdx.x * blockDim.x +threadIdx.x;
  //int stride = blockDim.x * gridDim.x;

  //printf("in the kernel with thread : %d",index);
    unsigned long key = Table_A[index*width+0];
    unsigned long value = Table_A[index*width+1]; //C
    unsigned long long entry = make_entry(key,value);
    //printf("entry: %d",entry);
    unsigned location = hash_function_1(key);
    for (int its = 0; its<maxiterations; its++){
    entry = atomicExch(&table[location], entry);
    key = getkey(entry);
    printf("key, %d \n",key);
    if (key == 0) { 
      printf("return");
      return;}
    unsigned location1 = hash_function_1(key);
    unsigned location2 = hash_function_2(key);
    if (location == location1)
     location = location2;
    else if (location == location2) 
     location = location1;
    };
    printf("chain was too long");
    return ;


   // printf("threadid: %d , table:%lu \n",index,table[location]);
    //__syncthreads();

}


int main()
{
  /* unsigned  key = 1;
   unsigned long long ans =0;
   ans = key<<32;
   printf("ans:  %ld",ans);*/

    
    int *Table_A;
    int *Table_B;
    int *Table_C;

    int width = 2;
    int height = 3;

    cudaMallocManaged(&Table_A, width * height * sizeof(int));
    cudaMallocManaged(&Table_B, width * height * sizeof(int));
    cudaMallocManaged(&Table_C, width * height * sizeof(int));


    Table_A[0]=1;
    Table_A[1]=4;
    Table_A[2]=2;
    Table_A[3]=5;
    Table_A[4]=3; 
    Table_A[5]=6;
    
    Table_B[0]=1;
    Table_B[1]=7;
    Table_B[2]=2;
    Table_B[3]=8;
    Table_B[4]=3; 
    Table_B[5]=9;

    cudaMemset(table, KEYEMPTY, TABLESIZE*sizeof(unsigned long long));

    hash_join<<<1,3>>>(Table_A, Table_B, width, height);
    cudaDeviceSynchronize();
    printf("exit ");
}