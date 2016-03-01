function x = f_rect(ts)
    x = zeros(size(ts));
    x(abs(ts)<=1) = 1;
endfunction
