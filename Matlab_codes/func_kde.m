function y = func_kde(s, x, h)
    res = 0;
    for i = 1 : length(s)
        res = res + nrmpdf((x-s(i))/h, 0, 1);
    end
    y = res / (length(s) * h);
end