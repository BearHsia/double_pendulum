clc;clear;close all;

T = 1000;

k1 = 100;
d1 = 0.5;
J1 = 1;
k2 = 100;
d2 = 0.5;
J2 = 1;
is_tm1 = 1;
is_tm2 = 1;
simuout = sim('pendulum_noratiobias',T);
figure(1);
plot(simuout.J1_est_param);
legend('J1','k1','d1')
%figure(2);
%plot(simuout.J1_est_error);
figure(3);
plot(simuout.J2_est_param);
legend('J2','k2','d2');
%figure(4);
%plot(simuout.J2_est_error);

