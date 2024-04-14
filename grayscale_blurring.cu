#include "stdio.h"
#include "math.h"

#define N 3
#define BLUR_SIZE (N-1/2)
#define channels 3

__global__  void color2grayscale(unsigned char *Pin, unsigned char *Pout, int width, int height){
  int row_num = blockIdx.y * blockDim.y + threadIdx.y;
  int col_num = blockIdx.x * blockDim.x + threadIdx.x;

  if(row_num < height && col_num < width){
    int grayscaleOffset = row_num * width + col_num;

    int rgbOffset = grayscaleOffset*channels;

    unsigned char r = Pin[rgbOffset];
    unsigned char g = Pin[rgbOffset + 1];
    unsigned char b = Pin[rgbOffset + 2];

    Pout[grayscaleOffset] = 0.21*r + 0.71*g + 0.07*b;
  }
}

__global__ void blurKernel(unsigned char* Pin, unsigned char* Pout, int width, int height){
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  int row = blockIdx.y * blockDim.y + threadIdx.y;

  if(col < width && row< height){
    int pixelVal = 0;
    int pixelCount = 0;

    for(int blurRow = -BLUR_SIZE; blurRow < BLUR_SIZE + 1; ++blurRow){
      for(int blurCol = -BLUR_SIZE; blurCol < BlUR_SIZE + 1; ++blurCol){
          int currRow = row + blurRow;
          int currCol = col + blurCol;

          if(currRow>= 0 && currRow < height && currCol >= 0 && currCol < width){
            pixelVal += Pin[currRow*width+currCol];
            pixelCount++;
          }
      }
    }
    Pout[row*width+col] = (unsigned char) (pixelVal/pixelCount++;);
  }
}

int main (){
  // Load in some image into 
  // Get the vertical (n) and horizontal (m) dimmensions of the image
  // Linearize the 2D image into a 1D array (Pin_h)
  // Create Pin_d and allocate its memory (cudaMalloc)
  // cudaMemcpy(Pin_d, Pin_h, size, cudaMemcpyHostToDevice);

  // Pin_h
  // Pout_h
  // Pin_d
  // Pout_d

  
  // Create a pointer to Pout_d allocate its memory (cudaMalloc) 
  // cudaMemcpy(Pout_d, Pout_h, size, cudaMemcpyHostToDevice);
  dim3 dimGrid(ceil(m/16.0), ceil(n/16.0), 1);
  dim3 dimBlock(16,16,1);

  color2grayscale<<<dimGrid, dimBlock>>> (Pin_d, Pout_d, m , n);
  // cudaMemcpy(Pout_h, Pout_d, size, cudaMemcpyDeviceToDevice);
  
}
