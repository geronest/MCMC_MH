function y = nrmpdf(x, m, sd)
    y = exp(-(x-m).^2/(2*sd^2)) / (sd*sqrt(2*pi));
end