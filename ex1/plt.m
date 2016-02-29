function plt()
    ts = linspace(0,1,1000);
    xs = fun(ts);
    dt = mean(diff(ts));
    plot(ts,xs);
endfunction