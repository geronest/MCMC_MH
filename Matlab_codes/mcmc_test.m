% range of x to examine
xx = [-14:.1:14];

% means and std.devs used for making target distributions
m = 1;
m2 = -5.5;
m3 = 6;
sd = 1;
sd2 = 1.5;
sd3 = 2;

% variables used for the algorithm
init = -18; % starting point of sampling
prev = init;
samples = [init]; % values sampled from target distribution
array_acpt = [];
array_acpt2 = [];
array_corr = []; 

% Target distributions - Try making your own!
func_sample2 = @(x) 0.5 * nrmpdf(x, m2, sd3) + 0.5 * nrmpdf(x, m3, sd3);

func_sample3 = @(x) 0.3 * nrmpdf(x, m, sd) + ...
    0.4 * nrmpdf(x, m2, sd2) + 0.3 * nrmpdf(x, m3, sd3);

func_sample = @(x) 0.3 * nrmpdf(x, m, sd) + ...
    0.4 * nrmpdf(x, m2, sd2) + 0.3 * nrmpdf(x, m3, sd3);

% Preparing a plot to be updated real-time
h(1) = figure;
f1 = plot(xx, func_sample(xx), xx, func_kde(samples(1), xx, 0.5), 'r', samples(1), 0, 'rO');

while size(samples) < 300
    % Calculate a sample candidate, based on previous value
    next = prev + 2*randn;
    acceptance = func_sample(next) / func_sample(prev);

    % Check acceptance, decide whether to use the value as a sample
    if acceptance > 1
        prev = next;
        samples = [samples prev];
        array_acpt = [array_acpt 1];
        array_acpt2 = [array_acpt2 1];
    else
        if rand() < acceptance
            prev = next;
            samples = [samples prev];
            array_acpt2 = [array_acpt2 acceptance];
        end
        array_acpt = [array_acpt acceptance];
    end
    y = func_kde(samples, xx, 0.5);

    % update plot
    set(f1(2), 'XData', xx);
    set(f1(2), 'YData', y);
    set(f1(3), 'XData', samples);
    set(f1(3), 'YData', zeros(1, length(samples)));
    refreshdata;
    drawnow;
    %pause();
end

% Check Kullback-Leibler divergence
kl_div = 0;
for i = 1:length(xx)
    p1 = func_sample(xx(i));
    p2 = func_kde(samples, xx(i), 0.5);
    kl_div = kl_div + p1 * log(p1 / p2);
end

kl_div

% Calculate correlation coefficients
for i = 1 : 100
    corr = sample_corr(samples, i);
    array_corr = [array_corr corr(1, 2)]; % Jiseob : Make sure you initialize the arrays beforehand.
end

% Check acceptance rate
size(array_acpt2) / size(array_acpt)

h(2) = figure;
f2 = plot(1:length(array_acpt), array_acpt, 'ro');
h(3) = figure;
f3 = plot(1:length(array_acpt2), array_acpt2, 'bo');
h(4) = figure;
f4 = plot(1:100, array_corr);
savefig(h, 'figures.fig');




