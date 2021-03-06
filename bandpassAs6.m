function y = bandpassAs6(x,fa,flower,fupper)
%BANDPASSAS6 Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.6 and the DSP System Toolbox 9.1.
% Generated on: 10-Mar-2016 09:36:45

persistent Hd;

if isempty(Hd)
    
    Fstop1 = flower*0.9;   % First Stopband Frequency
    Fpass1 = flower;   % First Passband Frequency
    Fpass2 = fupper;  % Second Passband Frequency
    Fstop2 = fupper*1.1;  % Second Stopband Frequency
    Astop1 = 6;       % First Stopband Attenuation (dB)
    Apass  = 1;       % Passband Ripple (dB)
    Astop2 = 6;       % Second Stopband Attenuation (dB)
    Fs     = fa;  % Sampling Frequency
    
    h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
        Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
    
    Hd = design(h, 'butter', ...
        'FilterStructure', 'df1sos', ...
        'MatchExactly', 'stopband', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);


