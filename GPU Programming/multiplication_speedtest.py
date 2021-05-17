# -*- coding: utf-8 -*-
"""
Created on Mon May 17 10:31:28 2021

@author: aishw
"""
# Pointwise multiplication speed test

import numpy as np
import pycuda.autoinit
from pycuda import gpuarray
from time import time

# Generate 50 million random values of dtype = float32
host_data = np.float32(np.random.random(5000000))

# CPU Multiplication
t1 = time()
host_data_2x = host_data * np.float32(2)
t2 = time()
print(f'Total time to compute on CPU: {t2-t1}')

# GPU Multiplication
device_data = gpuarray.to_gpu(host_data)
t1 = time()
device_data_2x = device_data * np.float32(2)
t2= time()
from_device = device_data_2x.get()
print(f'Total time to compute on GPU: {t2-t1}')

# Observations:
# - first run GPU time > CPU time. 
# -- Reason: PyCUDA library GPU code is often compiled and linked with NVIDIA's nvcc compiler the first time it is run in a given Python session. 
# -- It is then cached and if the code is called again, then it doesnot have to be recompiled.
# -- first run will have calls to compiler whereas subsequent runs wont call the compiler
# - for all other runs GPU time << CPU time