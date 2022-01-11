function kernel = gausianKernel

x = [-4 -3 -2 -1 0 1 2 3 4];
y = -4:1:4;
sigma = 1;

kernel = zeros(9,9);
n = length(x);
 
for i=1:n
    for j=1:n
        kernel(i,j) = (1/(2*pi*(sigma^2)))*exp(-((x(i)^2+y(j)^2)/(2*sigma^2)));
    end
end