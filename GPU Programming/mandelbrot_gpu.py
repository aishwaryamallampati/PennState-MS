# -*- coding: utf-8 -*-
"""
Created on Mon May 17 12:22:46 2021

@author: aishw
"""

import numpy as np
from time import time
import matplotlib
matplotlib.use('Agg') 
from matplotlib import pyplot as plt
import pycuda.autoinit
from pycuda import gpuarray
from pycuda.elementwise import ElementwiseKernel
from time import time

# kernel is written using inline CUDA-C
# - Even though input is 2D - CUDA will see it as 1D and index it by i
mandel_ker = ElementwiseKernel(
    "pycuda::complex<float> *lattice, float *mandelbrot_graph, int max_iters, float upper_bound",
    """
    mandelbrot_graph[i] = 1;
    pycuda::complex<float> c = lattice[i];
    pycuda::complex<float> z = (0,0);
    for(int j = 0; j < max_iters; j++){
        {
            z = z*z + c;
            if(abs(z) > upper_bound){
                mandelbrot_graph[i]=0;
                break;
            }
        }
    }
    """, "mandel_ker")

def gpu_mandelbrot(width, height, real_low, real_high, imaginary_low, imaginary_high, max_iters, upper_bound):
    real_vals = np.matrix(np.linspace(real_low, real_high, width), dtype=np.complex64)
    imag_vals = np.matrix(np.linspace(imaginary_low, imaginary_high, height), dtype=np.complex64) * 1j
    mandelbrot_lattice = np.array(real_vals + imag_vals.transpose(), dtype=np.complex64) # input 2D matrix - lattice
    
    # copy complex lattice to gpu
    mandelbrot_lattice_gpu = gpuarray.to_gpu(mandelbrot_lattice)
    # allocate empty array for output on the GPU
    mandelbrot_graph_gpu = gpuarray.empty(shape=mandelbrot_lattice.shape, dtype=np.float32)
    
    # Call the kernel
    mandel_ker(mandelbrot_lattice_gpu, mandelbrot_graph_gpu, np.int32(max_iters), np.float32(upper_bound))
    
    # Return result
    mandel_graph = mandelbrot_graph_gpu.get()
    return mandel_graph

if __name__ == '__main__':
    t1 = time()
    mandel = gpu_mandelbrot(512, 512, -2, 2, -2, 2, 256, 2)
    t2 = time()
    mandel_time = t2 - t1
    
    t1 = time()
    fig = plt.figure(1)
    plt.imshow(mandel, extent=(-2, 2, -2, 2))
    plt.savefig('gpu_mandelbrot.png', dpi=fig.dpi)
    t2 = time()
    dump_time = t2 - t1
    
    print(f'It took {mandel_time} sec to calculate the Mandelbrot graph.')
    print(f'It took {dump_time} sec to dump the image.')
    
    # Observations:
    # - CPU took 16sec whereas GPU took 1sec