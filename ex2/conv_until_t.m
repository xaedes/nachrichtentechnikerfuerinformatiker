function res = conv_until_t(f,g,ts,t)
    res = zeros(size(ts));
    res = conv_fft(f,g,ts);
    res(ts>t) = 0;
endfunction
