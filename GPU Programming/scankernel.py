# -*- coding: utf-8 -*-
"""
Created on Mon May 17 12:54:56 2021

@author: aishw
"""

import numpy as np
import pycuda.autoinit
from pycuda import gpuarray
from pycuda.scan import InclusiveScanKernel
from pycuda.scan import ReductionKernel

# Cumulative Summation
seq = np.array([1,2,3,4], dtype=np.int32)
seq_gpu = gpuarray.to_gpu(seq)
# InclusiveScanKernel needs datatype and lambda function
sum_gpu_ker = InclusiveScanKernel(np.int32, "a+b") 
sum_cpu = sum_gpu_ker(seq_gpu).get()
print(f'Sum using GPU: {sum_cpu}')
print(f'Sum using np: {np.cumsum(seq)}')

# Find max in a list
seq = np.array([1, 100, -3, -10000, 4, 10000, 66, 14, 21], dtype=np.int32)
seq_gpu = gpuarray.to_gpu(seq)
max_gpu_ker = InclusiveScanKernel(np.int32, "a > b ? a : b")
print(f'MAX using GPU: {max_gpu_ker(seq_gpu).get()[-1]}')
print(f'Max using np: {np.max(seq)}')

# Reduction Kernel acts like a ElementWiseKernel function followed by a parallel scan kernel
# Dot product of two vectors
# dot_product_ket = ReductionKernel(np.float32, neutral="0". reduce_expr="a+b", map_expr="vec1[i]*vec2[i]", arguments="float *vec1, float *vec2")



