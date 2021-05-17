# -*- coding: utf-8 -*-
"""
Created on Mon May 17 10:22:18 2021

@author: aishw
"""

import numpy as np
import pycuda.autoinit
from pycuda import gpuarray

# Always specify the dtype of the data that needs to be sent to the gpu. Reasons:
# - avoids unnecessary overhead 
# - easy to transfer code to CUDA C as C is statically-typed lang
host_data = np.array([1,2,3,4,5], dtype=np.float32)
device_data = gpuarray.to_gpu(host_data) # send data to gpu
device_data_x2 = 2 * device_data # perform computations - each multiplication is offloaded to one thread
host_data_x2 = device_data_x2.get() # get the result from gpu to cpu
print(f'Result:{host_data_x2}')