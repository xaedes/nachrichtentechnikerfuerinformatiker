function x = plot_functions (ts,functions,subplots=true)
    clf();
    n = numel(functions);
    for k = 1:n
        f = functions{k};
        name = f{1,1};
        func = f{1,2};
        if subplots
            subplot(1,n,k);
        endif
        ys = func(ts);
        plot(ts,ys);
        ylim([0,max(max(ys),1)+0.15]);
        grid('on');
        if !subplots
            hold('on');
        endif
    end

endfunction
