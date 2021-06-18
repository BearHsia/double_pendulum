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

simuout = sim('pendulum_noratiobias',T);

last_N = 100;
figure(1);
set(gcf,'position',[1000 250 455 250]);
plot(simuout.J1_est_param.Time, simuout.J1_est_param.data(:,1)/J1); hold on;
plot(simuout.J1_est_param.Time, simuout.J1_est_param.data(:,3)/d1);
plot(simuout.J1_est_param.Time, simuout.J1_est_param.data(:,2)/k1); hold off;
legend('$\hat{j}_{1}/j_{1}$','$\hat{d}_{1}/d_{1}$','$\hat{k}_{1}/k_{1}$','Interpreter','Latex');
ylabel('Normalized estimation value','Interpreter','Latex');
xlabel('Time (s)','Interpreter','Latex');
xlim([0 500]);
disp("Estimated J1:");
disp(mean(simuout.J1_est_param.data(end-last_N:end,1)));
disp("Estimated d1:");
disp(mean(simuout.J1_est_param.data(end-last_N:end,3)));
disp("Estimated k1:");
disp(mean(simuout.J1_est_param.data(end-last_N:end,2)));
ax = gca;
ax.FontSize = 10; 
ax.TickLabelInterpreter = 'Latex';
grid on;
title("Flexible Joint1 Parmater Estunation",'Interpreter','Latex');
%figure(2);
%plot(simuout.J1_est_error);

%figure(3);
%plot(simuout.J2_est_param);
%legend('J2','k2','d2');
%figure(4);
%plot(simuout.J2_est_error);
%figure(5);
%plot(simuout.L_est_param);
%legend('L1','L2');
%figure(6);
%plot(simuout.L_est_error);
% figure(7);
% plot(simuout.tow2_est_param);
% legend('Y1','Y2','Y3','Y4');
% figure(8);
% plot(simuout.tow2_est_error);
% figure(9);
% plot(simuout.Lf_est_param);
% legend('Lf1','Lf2');
% figure(10);
% plot(simuout.Lf_est_error);
