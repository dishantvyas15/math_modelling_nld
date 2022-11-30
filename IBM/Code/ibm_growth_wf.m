%% Initialize vars

close all; clear; clc;
growth_ibm = readmatrix('Data/growth_ibm.dat');

rev = growth_ibm(:,1);
hr = growth_ibm(:,2);
year = growth_ibm(:,3);




%% Naive plotting

figure(1);
subplot(1,2,1);
plot(year, rev);
title('Year-wise Revenue of IBM (linear scales)');
xlabel('n^{th} year after establishment');
ylabel('Revenue (in million $)');
grid on;
subplot(1,2,2);
plot(year, hr);
title('Year-wise HR Strength of IBM (linear scales)');
xlabel('n^{th} year after establishment');
ylabel('HR Strength');
grid on;
% saveas(gcf, '1__rev_hr_linear.png', 'png');




%% Fit revenue data

rev_eta = 10^(-5);
rev_alpha = 1;
rev_lambda = 0.145;
rev_c = 0;
for i=1:length(year)
    rev_c = rev_c + exp(-rev_lambda*year(i))*(rev(year(i))^(-rev_alpha)-rev_eta)^(-1/rev_alpha);
end
rev_c = rev_c/length(year);
% c = 2;
rev_est = (rev_eta + (rev_c^(-rev_alpha))*(exp(-rev_alpha*rev_lambda*year))).^(-1/rev_alpha);

cum_rev = cumsum(rev);
cum_rev_eta = 4*10^(-7);
cum_rev_c = 0;
for i=1:length(year)
    cum_rev_c = cum_rev_c + exp(-rev_lambda*year(i))*(cum_rev(year(i))^(-rev_alpha)-cum_rev_eta)^(-1/rev_alpha);
end
cum_rev_c = cum_rev_c/length(year);
% cum_c = 14;
cum_rev_est = (cum_rev_eta + (cum_rev_c^(-rev_alpha))*(exp(-rev_alpha*rev_lambda*year))).^(-1/rev_alpha);


figure(2);
loglog(year, rev, '+');
hold on;
loglog(year, rev_est);
hold on;
loglog(year, cum_rev, 'x');
hold on;
loglog(year, cum_rev_est);
hold on;
title('Year-wise Revenue of IBM (log-log scales)')
xlabel('n^{th} year after establishment');
ylabel('Revenue (in million $)');
grid on;
legend('Actual Revenue', 'Analytically estimated Revenue', 'Actual Cumulative Revenue', 'Analytically estimated Cumulative Revenue', 'location', 'northwest');
% saveas(gcf, '2__rev_loglog.png', 'png');

figure(3);
semilogy(year, rev, '+');
hold on;
semilogy(year, rev_est);
hold on;
semilogy(year, cum_rev, '*');
hold on;
semilogy(year, cum_rev_est);
hold on;
title('Year-wise Revenue of IBM (linear-log scales)')
xlabel('n^{th} year after establishment');
ylabel('Revenue (in million $)');
grid on;
legend('Actual Revenue', 'Analytically estimated Revenue', 'Actual Cumulative Revenue', 'Analytically estimated Cumulative Revenue', 'location', 'southeast');
% saveas(gcf, '3__rev_linlog.png', 'png');




%% Fit human resource data

hr_eta = 2*10^(-6);
hr_alpha = 1;
hr_lambda = 0.09;
hr_c = 0;
for i=1:length(year)
    hr_c = hr_c + exp(-hr_lambda*year(i))*(hr(year(i))^(-hr_alpha)-hr_eta)^(-1/hr_alpha);
end
hr_c = hr_c/length(year);
% hr_c = 1400;
hr_est = (hr_eta + (hr_c^(-hr_alpha))*(exp(-hr_alpha*hr_lambda*year))).^(-1/hr_alpha);

figure(4);
loglog(year, hr, '+');
hold on;
loglog(year, hr_est);
hold on;
title('Year-wise HR Strength of IBM (log-log scales)')
xlabel('n^{th} year after establishment');
ylabel('Human Resource Strength');
grid on;
legend('Actual HR Strength', 'Analytically estimated HR Strength', 'location', 'northwest');
% saveas(gcf, '4__hr_loglog.png', 'png');

figure(5);
semilogy(year, hr, '+');
hold on;
semilogy(year, hr_est);
hold on;
title('Year-wise HR Strength of IBM (linear-log scales)')
xlabel('n^{th} year after establishment');
ylabel('Human Resource Strength');
grid on;
legend('Actual HR Strength', 'Analytically estimated HR Strength', 'location', 'southeast');
% saveas(gcf, '5__hr_linlog.png', 'png');




%% Data Manipulation and Plotting

rev_manip = log(rev.^(-rev_alpha) - rev_eta);
rev_fit_line_m = -0.155;
rev_fit_line_c = 0;

figure(6);
plot(year, rev_manip);
hold on;
plot(year, rev_fit_line_m*year + rev_fit_line_c);
hold on;
title('ln(rev^{-\alpha_{rev}} - \eta_{rev}) vs. t')
xlabel('n^{th} year after establishment');
ylabel('Revenue');
grid on;
legend('Manipulated Revenue', 'Revenue fitting line');
% saveas(gcf, '6__rev_manip.png', 'png');

hr_manip = log(hr.^(-hr_alpha) - hr_eta);
hr_fit_line_m = -0.1;
hr_fit_line_c = -7;

figure(7);
plot(year, hr_manip);
hold on;
plot(year, hr_fit_line_m*year + hr_fit_line_c);
hold on;
title('ln(hr^{-\alpha_{hr}} - \eta_{hr}) vs. t')
xlabel('n^{th} year after establishment');
ylabel('Human Resource Strength');
grid on;
legend('Manipulated HR Strength', 'HR Strength fitting line');
% saveas(gcf, '7__hr_manip.png', 'png');




%% Differential Equations' plotting

d_by_dt_rev = rev_lambda*rev.*(1-rev_eta*rev.^rev_alpha);
d_by_dt_hr = hr_lambda*hr.*(1-hr_eta*hr.^hr_alpha);

drev1 = rev;
for i=2:length(rev)
    drev1(i) = rev(i)-rev(i-1);
end
drev2 = rev;
for i=1:length(rev)-1
    drev2(i) = rev(i+1)-rev(i);
end
drev = (drev1+drev2)/2;

dhr1 = hr;
for i=2:length(hr)
    dhr1(i)=hr(i)-hr(i-1);
end
dhr2 = hr;
for i=1:length(hr)-1
    dhr2(i) = hr(i+1)-hr(i);
end
dhr = (dhr1+dhr2)/2;

figure(8);
% subplot(1,2,1);
% plot(rev, d_by_dt_rev);
% hold on;
% plot(rev_est, d_by_dt_rev_est);
% hold on;
% title('IBM Revenue values displaying parabolic behavior of Logistic Equation')
% xlabel('Revenue');
% ylabel('(d/dt)(Revenue) found through DE');
% grid on;
% legend('Ideal', 'Actual', 'location', 'south');
% subplot(1,2,2);
plot(rev, d_by_dt_rev);
hold on;
plot(rev, drev, '+');
hold on;
title('IBM Revenue values displaying parabolic behavior of Logistic Equation')
xlabel('Revenue');
ylabel('(\delta/\deltat)(Revenue)');
grid on;
legend('Ideal', 'Actual', 'location', 'south');
% saveas(gcf, '8__rev_parabola.png', 'png');

figure(9);
% subplot(1,2,1);
% plot(hr, d_by_dt_hr);
% hold on;
% plot(hr_est, d_by_dt_hr_est);
% hold on;
% title('IBM HR Strength values failing to display parabolic behavior of Logistic Equation')
% xlabel('HR Strength');
% ylabel('(\delta/\deltat)(HR Strength)');
% grid on;
% legend('Ideal', 'Actual', 'location', 'south');
% subplot(1,2,2);
plot(hr, d_by_dt_hr);
hold on;
plot(hr, dhr, '+');
hold on;
title('IBM HR Strength values failing to display parabolic behavior of Logistic Equation')
xlabel('HR Strength');
ylabel('(\delta/\deltat)(HR Strength)');
grid on;
legend('Ideal', 'Actual', 'location', 'south');
% saveas(gcf, '9__hr_parabola.png', 'png');




%% Revenue vs. HR Strength

figure(10);
loglog(hr, cum_rev);
hold on;
coeffs = polyfit(log(hr), log(cum_rev), 1);
loglog(hr, exp(polyval(coeffs, log(hr))));

hold on;
title('IBM HR Strength vs. Cumulative Revenue')
xlabel('HR Strength');
ylabel('Cumulative Revenue');
legend('Actual', 'Fitted', 'location', 'southeast');
grid on;
% saveas(gcf, '10__hr_vs_cum_rev.png', 'png');
