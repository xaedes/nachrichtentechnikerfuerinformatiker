function x = plot1 (ts,functions,subplots=true)
    [t_min,t_max,n] = conf();
    ts = linspace(t_min,t_max,n);
    plot_functions(ts,{{'rect',@f_rect},{'ramp',@g_ramp}});

endfunction


