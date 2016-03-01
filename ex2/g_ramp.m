function x = g_ramp(ts)
    x = zeros(size(ts));
    leq2 = abs(ts)<=2;
    x(leq2) = exp(-2-ts(leq2));
endfunction
