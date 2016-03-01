function convoluted = conv_fft(f,g,ts)
    res = zeros(size(ts));

    f_spectrum = fft(f(ts));
    g_spectrum = fft(g(ts));
    conv_spect = f_spectrum .* g_spectrum;
    convoluted = ifft(conv_spect);
    convoluted = fftshift(convoluted);
    convoluted = convoluted / max(convoluted);
endfunction
