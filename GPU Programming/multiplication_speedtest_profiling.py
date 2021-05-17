# -*- coding: utf-8 -*-
"""
Created on Mon May 17 10:40:01 2021

@author: aishw
"""
# Profiling code
with open('multiplication_speedtest.py', 'r') as f:
    time_calc_code = f.read()

%prun -s cumulative exec(time_calc_code)
