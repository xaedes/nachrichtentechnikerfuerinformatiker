function makefft(N=10000)
    ts = linspace(0,1,N);
    xs = fun(ts);
    dt = mean(diff(ts));
    sp = fft(xs);

    freq = (0:N-1)/(N*dt);

    % one sided
    sp = sp(1,1:N/2);
    freq = freq(1,1:N/2);

    plot(freq,abs(sp));

endfunction