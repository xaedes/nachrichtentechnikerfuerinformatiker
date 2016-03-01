function plot_at_t (t)
    [t_min,t_max,n] = conf();
    ts = linspace(t_min,t_max,n);
    g = @(ts) g_ramp(t-ts);

    plot_functions(ts,{
        {'rect',@f_rect},
        {'ramp',g},
        {'conv',@(ts)conv_until_t(@f_rect,@g_ramp,ts,t)}
    },false);

endfunction

