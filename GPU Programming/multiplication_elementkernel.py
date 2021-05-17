# -*- coding: utf-8 -*-
"""
Created on Mon May 17 10:53:41 2021

@author: aishw
"""

import numpy as np
import pycuda.autoinit
from pycuda import gpuarray
from time import time 
from pycuda.elementwise import ElementwiseKernel
host_data = np.float32(np.random.random(50000000))
# input and outpur args, operation, kernel name
gpu_2x_ker = ElementwiseKernel("float *in, float *out", "out[i]=2*in[i];", "gpu_2x_ker")

def speedcomparison():
    # CPU Multiplication
    t1 = time()
    host_data_2x = host_data * np.float32(2)
    t2 = time()
    print(f'Total time to compute on CPU: {t2-t1}')

    # GPU Multiplication
    device_data = gpuarray.to_gpu(host_data)
    # allocate memory for output
    device_data_2x = gpuarray.empty_like(device_data) # similar to malloc in C
    t1 = time()
    gpu_2x_ker(device_data, device_data_2x)
    t2= time()
    from_device = device_data_2x.get()
    print(f'Total time to compute on GPU: {t2-t1}')
    print(f'Is the host computation the same as the GPU computation? : {np.allclose(from_device, host_data_2x)}')
    
if __name__ == '__main__':
    speedcomparison()