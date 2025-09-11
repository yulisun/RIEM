function x = remove_outlier(y,n)
x = y;
if (~exist('n','var'))
    n=3;
end
outliers = y - mean(y(:)) > n*std(y(:));
x(outliers) = max(max(x(~outliers)));