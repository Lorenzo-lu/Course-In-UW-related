clear
%close all
clc

n = 100;
l = 10000;
b = zeros([l,1]);
for i = 1:n
    a = normrnd(0,1,[l,1]);
    b = b + a;
end

figure();
histogram(b/n);