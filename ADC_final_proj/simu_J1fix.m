clc;clear;close all;

T = 1000;

k1 = 100;
d1 = 0.5;
J1 = 1;
k2 = 80;
d2 = 0.5;
J2 = 0.8;
is_tm1 = 1;
is_tm2 = 1;
L1 = 0.4;
L2 = 0.2;
m2 = 1;
Lc2 = L2/2;
Izz2 = 2;

% finite time parameters
lf1 = 0.1;
theta_f = 0.1;
gama_f = 0.1;

simuout = sim('pendulum_noratiobias_J1fix.slx',T);

last_N = 100;
figure(1);
set(gcf,'position',[1000 250 455 250]);
plot(simuout.J2_est_param.Time, simuout.J2_est_param.data(:,1)/J2); hold on;
plot(simuout.J2_est_param.Time, simuout.J2_est_param.data(:,3)/d2);
plot(simuout.J2_est_param.Time, simuout.J2_est_param.data(:,2)/k2); hold off;
legend('$\hat{j}_{2}/j_{2}$','$\hat{d}_{2}/d_{2}$','$\hat{k}_{2}/k_{2}$','Interpreter','Latex');
ylabel('Normalized estimation value','Interpreter','Latex');
xlabel('Time (s)','Interpreter','Latex');
xlim([0 500]);
disp("Estimated J2:");
disp(mean(simuout.J2_est_param.data(end-last_N:end,1)));
disp("Estimated d2:");
disp(mean(simuout.J2_est_param.data(end-last_N:end,3)));
disp("Estimated k2:");
disp(mean(simuout.J2_est_param.data(end-last_N:end,2)));
ax = gca;
ax.FontSize = 10; 
ax.TickLabelInterpreter = 'Latex';
grid on;
title("Flexible Joint2 Parmater Estunation",'Interpreter','Latex');