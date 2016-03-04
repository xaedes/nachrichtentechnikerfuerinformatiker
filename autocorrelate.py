#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import numpy as np 

def _mean(arr):
    if arr.shape[0] == 0:
        return 0.
    else:
        return np.mean(arr)

def autocorrelate(xs,tau,autocorr_type=0):
    if tau == 0:
        s1 = xs
        s2 = xs
    elif tau > 0:
        s1 = xs[:-tau]
        s2 = xs[tau:]
    elif tau < 0:
        s1 = xs[:tau]
        s2 = xs[-tau:]
        
    mu = _mean(xs)
    mu1 = _mean(s1)
    mu2 = _mean(s2)
    var = np.std(xs)**2
    
    if autocorr_type==0:
        return np.sum(s1*s2)
    elif autocorr_type==1:
        return _mean(s1*s2)
    elif autocorr_type==2:
        return _mean((s1-mu1)*(s2-mu2))
    elif autocorr_type==3:
        return _mean((s1-mu)*(s2-mu))/var
    elif autocorr_type==4:
        return _mean((s1-mu)*(s2-mu))
    elif autocorr_type==5:
        return _mean(s1*s2)/var
    elif autocorr_type==6:
        return np.sum(s1*s2)/var
    elif autocorr_type==7:
        return _mean((s1-mu1)*(s2-mu2))/var
    elif autocorr_type==8:
        return np.sum(s1*s2)*var
