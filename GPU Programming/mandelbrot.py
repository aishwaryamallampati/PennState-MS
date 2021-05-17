# -*- coding: utf-8 -*-
"""
Created on Sun May 16 10:40:08 2021

@author: aishw
"""

# The Mandelbrot Set: 
import numpy as np
from time import time
import matplotlib
matplotlib.use('Agg') 
from matplotlib import pyplot as plt



def simple_mandelbrot(width, height, real_low, real_high, imaginary_low, imaginary_high, max_iters):
    real_vals = np.linspace(real_low, real_high, width)
    imag_vals = np.linspace(imaginary_low, imaginary_high, height)
    
    mandelbrot_graph = np.ones((height, width), dtype = np.float32)
    
    # Iterate through each cell
    for x in range(width):
        for y in range(height):
            c = np.complex64(real_vals[x] + imag_vals[y] * 1j)
            z = np.complex64(0)
            for i in range(max_iters):
                z = z**2 + c
                if(np.abs(z) > 2):
                    # z is a not a member of mandelbrot set - so set it to 0
                    mandelbrot_graph[y, x] = 0
                    break
    return mandelbrot_graph

if __name__ == '__main__':
    t1 = time()
    mandel = simple_mandelbrot(512, 512, -2, 2, -2, 2, 256)
    t2 = time()
    mandel_time = t2 - t1
    
    t1 = time()
    fig = plt.figure(1)
    plt.imshow(mandel, extent=(-2, 2, -2, 2))
    plt.savefig('mandelbrot.png', dpi=fig.dpi)
    t2 = time()
    dump_time = t2 - t1
    
    print(f'It took {mandel_time} sec to calculate the Mandelbrot graph.')
    print(f'It took {dump_time} sec to dump the image.')
    