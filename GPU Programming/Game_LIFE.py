# -*- coding: utf-8 -*-
"""
Created on Tue May 18 17:49:56 2021

@author: aishw
"""

'''
The Game of LIFE rules:
    Any live cell with fewer than two live neighbors dies
    Any live cell with two or three neighbors lives
    Any live cell with more than three neighbors dies
    Any dead cell with exactly three neighbors comes to life
'''

import pycuda.autoinit
import pycuda.driver as drv
from pycuda import gpuarray
from pycuda.compiler import SourceModule
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Grid -> Block -> thread
# Each block supports only 1024 threads so max dimensions of block will be 32*32
ker = SourceModule("""
// #define is used for creating macros. _X is replaced everywhere with the definition at compile time.                   
#define _X ( threadIdx.x + blockIdx.x * blockDim.x )
#define _Y ( threadIdx.y + blockIdx.y * blockDim.y )  
// _WIDTH and _HEIGHT correspond to the entire dimensions of the lattice      
#define _WIDTH ( blockDim.x * gridDim.x )
#define _HEIGHT ( blockDim.y * gridDim.y )
// _XM(x) and _YM(y) are used to handle edge cases on the grid in the game
#define _XM(x) ( (x + _WIDTH) % _WIDTH )
#define _YM(y) ( (y + _HEIGHT) % _HEIGHT )     
//_INDEX(x,y): 2d arrays in python are passed row-wise as 1d pointers in C
#define _INDEX(x,y) ( _XM(x) + _YM(y) * _WIDTH )   

// device func - serial, called by multiple threads in parallel by the kernel
__device__ int nbrs(int x, int y, int *in)
{
     return ( in[ _INDEX(x -1, y+1) ] + in[ _INDEX(x-1, y) ] + in[ _INDEX(x-1, y-1) ] \
                   + in[ _INDEX(x, y+1)] + in[_INDEX(x, y - 1)] \
                   + in[ _INDEX(x+1, y+1) ] + in[ _INDEX(x+1, y) ] + in[ _INDEX(x+1, y-1) ] );
}   

__global__ void conway_ker(int *lattice_out, int *lattice)
{
 int x = _X, y = _Y; // current cell covered by the thread
 int n = nbrs(x, y, lattice); // number of neighbors for the current cell
 
 if(lattice[_INDEX(x,y) == 1])
 {
  if(n==2 || n==3){
          lattice_out[_INDEX(x,y)] = 1;
          }
  else{
       lattice_out[_INDEX(x,y)] = 0;
       }
  } 
  else if(lattice[_INDEX(x,y)] == 0)
  {
  if(n==3){
          lattice_out[_INDEX(x,y)] = 1;
          }
  else{
       lattice_out[_INDEX(x,y)] = 0;
       }
   }
}   
    """)
    
conway_ker = ker.get_function("conway_ker")

# frameNum - used by animation module
# img - cell lattice
# N - width and height of lattice
def update_gpu(frameNum, img, newLattice_gpu, lattice_gpu, N):
    # thread count should not exceed 1024 - 32*32 or 16 * 64 or 10*10 anything can be used for block size
    conway_ker(newLattice_gpu, lattice_gpu, grid=(N//32, N//32, 1), block=(32,32,1))
    # Set output
    img.set_data(newLattice_gpu.get())
    lattice_gpu[:] = newLattice_gpu[:]
    return img

if __name__ == '__main__':
    N = 256 # lattice size
    lattice = np.int32(np.random.choice([1,0], N*N, p=[0.25, 0.75]).reshape(N, N))
    lattice_gpu = gpuarray.to_gpu(lattice)
    newLattice_gpu = gpuarray.empty_like(lattice_gpu)
    
    # Displaying the simulation
    fig, ax = plt.subplots()
    img = ax.imshow(lattice_gpu.get(), interpolation='nearest')
    ani = animation.FuncAnimation(fig, update_gpu, fargs=(img, newLattice_gpu, lattice_gpu, N, ) , interval=0, frames=1000, save_count=1000) 
    plt.draw()