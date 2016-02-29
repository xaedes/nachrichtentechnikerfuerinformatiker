function x = fun (t)
    mu = 0.5;
    sigma = sqrt(0.1);
    freq = 100;

    x = (1+sin(2*pi*freq*t)) .* exp(-((t-mu)/sigma).^2);
endfunction