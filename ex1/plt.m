function plt(N=1000)
    ts = linspace(0,1,N);
    xs = fun(ts);
    dt = mean(diff(ts));
    plot(ts,xs);
endfunction