function y = sample_corr(s, itv)
    v1 = s(1:end-itv);
    v2 = s(1+itv : end);
    y = corrcoef(v1, v2);
end