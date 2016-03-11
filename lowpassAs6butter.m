function y = lowpassAs6butter(x,fa,fupper)
%LOWPASSAS6BUTTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.6 and the DSP System Toolbox 9.1.
% Generated on: 10-Mar-2016 10:22:52

persistent Hd;

if isempty(Hd)
    
    N     = 8;     % Order
    Fpass = fupper/fa;   % Passband Frequency
    Fstop = fupper/fa*1.03;  % Stopband Frequency
    
    h = fdesign.lowpass('n,fp,fst', N, Fpass, Fstop);
    
    Hd = design(h, 'iirlpnorm', ...
        'FilterStructure', 'df1sos');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);

