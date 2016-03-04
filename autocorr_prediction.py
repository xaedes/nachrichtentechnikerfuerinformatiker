#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import numpy as np 
from autocorrelate import autocorrelate

def build_matrix(arr):
    p = arr.shape[0]
    matrix = np.zeros(shape=(p,p))
    matrix[0:,0] = arr[:] 
    matrix[0,0:] = arr[:]       
    for i in xrange(1,p):
        matrix[i:,i] = arr[:-i] 
        matrix[i,i:] = arr[:-i] 
    return matrix

def test_build_matrix():
	np.testing.assert_almost_equal( build_matrix(np.arange(3)), 
    array([[ 0.,  1.,  2.],
           [ 1.,  0.,  1.],
           [ 2.,  1.,  0.]]))

def predict(signal_history, verbose = False, autocorr_type=0):
    signal_history = np.asarray(signal_history)
    signal_history_rev = signal_history[::-1]
    p = signal_history.shape[0]
    tau = range(0,p+1)
    corr = lambda tau:autocorrelate(signal_history,tau,autocorr_type)
    autocorr = np.array(map(corr,tau))
    autocorr_matrix = build_matrix(autocorr[:-1])
    autocorr = autocorr[1:]
    try:
    	autocorr_matrix_inv = np.linalg.inv(autocorr_matrix)
    except np.linalg.LinAlgError:
    	return 0
    	
    w = autocorr_matrix_inv.dot(autocorr)
    prediction = np.sum(signal_history_rev * w)
    
    if verbose:
        print "autocorr_matrix"
        print autocorr_matrix
        print "autocorr_matrix_inv"
        print autocorr_matrix_inv
        print "autocorr"
        print autocorr
        print "w"
        print w
        print "signal_history_rev"
        print signal_history_rev
        print "prediction"
        print prediction
    
    return prediction

def test_predict():
	np.assert_almost_equal(predict([0,1,2]), 0.75294117647058822)
	np.assert_almost_equal(predict([3,-3,2]), -0.76016566265060215)
	np.assert_almost_equal(predict([0,1]), 0)
	np.assert_almost_equal(predict([1,0]), 0)
	np.assert_almost_equal(predict([1,3]), 0.89010989010989028)

def predict_n(signal, n_predict, time_horizon = None, verbose = False, autocorr_type=0):
    n = signal.shape[0]
    signal_prediction = np.zeros(shape=(n+n_predict))
    signal_prediction[:n] = signal
        
    for i in xrange(n,n+n_predict):
        if time_horizon is None:
            history = signal_prediction[:i]
        else:
            history = signal_prediction[max(0,i-time_horizon):i]
        signal_prediction[i] = predict(history, verbose, autocorr_type)
    
    return signal_prediction
    