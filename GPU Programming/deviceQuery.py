# -*- coding: utf-8 -*-
"""
Created on Sun May 16 13:08:36 2021

@author: aishw
"""

import pycuda.driver as drv

# Always initialize pycuda driver with init() or autoinit()
drv.init()
print(f'Detected {drv.Device.count()} CUDA Capable device(s).')

for i in range(drv.Device.count()):
    gpu_device = drv.Device(i)
    print(f'Device {i}: {gpu_device.name()}') # name of the GPU
    compute_capability = float('%d.%d'%gpu_device.compute_capability()) # GPU version number 
    print(f'Compute Capability: {compute_capability}')
    print(f'Total Memory: {gpu_device.total_memory()//(1024**2)} megabytes.')
    
    # Get the properties of the device in the form of a dict
    device_attributes_tuples = gpu_device.get_attributes().items()
    device_attributes = {}
    for k, v in device_attributes_tuples:
        device_attributes[str(k)] = v
        
    
    num_mp = device_attributes['MULTIPROCESSOR_COUNT']
    # The number of cores per mp is determined by the compute_capability
    # https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capabilities
    cuda_cores_per_mp = { 7.0 : 128, 7.2 : 16, 7.5 : 128, 8.0 : 128, 8.6 : 128}
    total_num_of_cores = num_mp * cuda_cores_per_mp[compute_capability]
    print(f'Number of mp:{num_mp} cuda_cores_per_mp:{cuda_cores_per_mp[compute_capability]}')
    print(f'Total number of cores: {total_num_of_cores}\n')
    
    # Print all the attributes of the device
    for k in device_attributes.keys():
        print(f'{k}: {device_attributes[k]}')