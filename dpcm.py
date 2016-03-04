#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import numpy as np 
import math

from autocorrelate import autocorrelate
from autocorr_prediction import predict, predict_n

def next_dpcm_signal(sent, next_value, time_horizon):
    sent = np.asarray(sent)
    time_horizon = min(time_horizon,sent.shape[0])
    if time_horizon < 2:
        return next_value

    history = sent[-time_horizon:]
    prediction = predict(history)

    correction = next_value - prediction

    return correction

def signal_to_dpcm(signal, time_horizon):
    signal = np.asarray(signal)
    corrections = np.zeros_like(signal,dtype="float")
    n = signal.shape[0]
    for k in range(0,n):
        corrections[k] = next_dpcm_signal(signal[:k], signal[k], time_horizon)

    return corrections

def receive_dpcm_correction(received, next_correction, time_horizon):
    received = np.asarray(received)
    if received.shape[0] < 2:
        return next_correction

    time_horizon = min(time_horizon,received.shape[0])
    history = received[-time_horizon:]
    prediction = predict(history)

    return next_correction + prediction

def dpcm_to_signal(corrections, time_horizon):
    corrections = np.asarray(corrections)
    n = corrections.shape[0]
    received = np.zeros(shape=n)

    for k in range(0,n):
        received[k] = receive_dpcm_correction(received[:k],corrections[k], time_horizon)

    return received

def test():
    signal = np.sin(np.linspace(0,2*math.pi,100))
    time_horizon = 10
    np.testing.assert_almost_equal(
        dpcm_to_signal(signal_to_dpcm(signal,time_horizon),time_horizon),
        signal)
    