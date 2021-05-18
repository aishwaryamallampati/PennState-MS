# -*- coding: utf-8 -*-
"""
Created on Tue May 18 17:30:39 2021

@author: aishw
"""

import pycuda.autoinit
import pycuda.driver as drv
import numpy as np
from pycuda import gpuarray
from pycuda.compiler import SourceModule
'''
SourceModule allows us to write kernels from scratch
SouceModule compiles code into a CUDA module.
'''

# Multiplication of vector by a scalar
# global keyword tells the compiler that the function is a kernel
# threadIdx is used to identify particualar thread which is automatically assigned in ElementwiseKernel
ker = SourceModule("""
    __global__ void scalar_multiply_kernel(float *outvec, float scalar, float *vec)
    {
     int i = threadIdx.x;
     outvec[i] = scalar * vec[i];
     }
    """)
    


# Extract reference to the function 
scalar_multiply_gpu = ker.get_function("scalar_multiply_kernel")
testvec = np.random.randn(512).astype(np.float32)
testvec_gpu = gpuarray.to_gpu(testvec)
outvec_gpu = gpuarray.empty_like(testvec_gpu)
# scalar value 2 is a singleton value so it can be passed directly from host without using pointers or allocated device memory
scalar_multiply_gpu(outvec_gpu, np.float32(2), testvec_gpu, block=(512,1,1), grid=(1,1,1))

print(f'Does our kernel work correctly: {np.allclose(outvec_gpu.get(), 2*testvec)}')