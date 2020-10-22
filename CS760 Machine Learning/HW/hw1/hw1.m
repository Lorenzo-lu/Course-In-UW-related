clear
close all
clc

xmin = -5;
xmax = 5;
ymin = -5;
ymax = 5;

i = 1;
%% Q1
cov = [1 0;0 1];
mu = [0;0];
output = mvnrnd(mu,cov,100);

figure();
pt1 = plot(output(:,1),output(:,2),'.');
axis([xmin,xmax,ymin,ymax]);
xlabel('X');
ylabel('Y');
title(['8-',num2str(i)]);
%scatter(output(:,1),output(:,2));
filename = ['hw1-8-',num2str(i),'.jpg']
saveas(pt1,filename,'jpg');

i = i + 1;
%% Q2
cov = [1 0;0 1];
mu = [1;-1];
output = mvnrnd(mu,cov,100);

figure();
pt1 = plot(output(:,1),output(:,2),'.');
axis([xmin,xmax,ymin,ymax]);
xlabel('X');
ylabel('Y');
title(['8-',num2str(i)]);
%scatter(output(:,1),output(:,2));
filename = ['hw1-8-',num2str(i),'.jpg']
saveas(pt1,filename,'jpg');

i = i + 1;

%% Q3
cov = [2 0;0 2];
mu = [0;0];
output = mvnrnd(mu,cov,100);

figure();
pt1 = plot(output(:,1),output(:,2),'.');
axis([xmin,xmax,ymin,ymax]);
xlabel('X');
ylabel('Y');
title(['8-',num2str(i)]);
%scatter(output(:,1),output(:,2));
filename = ['hw1-8-',num2str(i),'.jpg']
saveas(pt1,filename,'jpg');

i = i + 1;

%% Q4
cov = [2 0.2;0.2 2];
mu = [0;0];
output = mvnrnd(mu,cov,100);

figure();
pt1 = plot(output(:,1),output(:,2),'.');
axis([xmin,xmax,ymin,ymax]);
xlabel('X');
ylabel('Y');
title(['8-',num2str(i)]);
%scatter(output(:,1),output(:,2));
filename = ['hw1-8-',num2str(i),'.jpg']
saveas(pt1,filename,'jpg');

i = i + 1;

%% Q5
cov = [2 -0.2;-0.2 2];
mu = [0;0];
output = mvnrnd(mu,cov,100);

figure();
pt1 = plot(output(:,1),output(:,2),'.');
axis([xmin,xmax,ymin,ymax]);
xlabel('X');
ylabel('Y');
title(['8-',num2str(i)]);
%scatter(output(:,1),output(:,2));
filename = ['hw1-8-',num2str(i),'.jpg']
saveas(pt1,filename,'jpg');

i = i + 1;

