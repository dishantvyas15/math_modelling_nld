close all; clear; clc;
ibm_prof_dat = readmatrix('ibm_prof.dat');

year = ibm_prof_dat(:,1);
prof = ibm_prof_dat(:,2);


%% Fit profit data on linear scales

figure(10);
grid on;
plot(year, prof);
hold on;
title('Year-wise net profit of IBM')
xlabel('n^{th} year after establishment');
ylabel('Net Profit (in million $)');
grid on;
% saveas(gcf, '10_profit.png', 'png');