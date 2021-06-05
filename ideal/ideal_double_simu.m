clc;clear;close all;

%% Inertia param
ixx1 = 1;             %[kg m^2]
iyy1 = 1;             %[kg m^2]
izz1 = 1;             %[kg m^2]
ixx2 = 1;             %[kg m^2]
iyy2 = 1;             %[kg m^2]
izz2 = 1;             %[kg m^2]
m1 = 1;           %[kg]
m2 = 1;           %[kg]
g = 9.80665;          %[m/s^2]

%% Link length param
l1 = 0.2;               %[m]
l2 = 0.2;               %[m]
lc1 = l1*0.5;       %[m]
lc2 = l2*0.5;       %[m]

%% Rotation matrix
th1_ic = -pi/2;             %[rad]
th2_ic = 0;            %[rad]
th1_d_ic=0;             %[rad/s]
th2_d_ic=0;             %[rad/s]
th_ic = [th1_ic th2_ic];
th_d_ic = [th1_d_ic th2_d_ic];
len_th = length(th_ic);

%% Simulation condition
T = 10;                  %Simulation time
dt = 0.0001;             %Sampling time
N = floor(T/dt);         %Steps
t = (0:1:N)'*dt;

%% Definition of states
%Rotary pendulum states
qn = zeros(N+1,len_th);    %Generalized coordinates
un = zeros(N+1,len_th);    %Generalized velocities

%setting initial condition
qn(1,:) = th_ic;              
un(1,:) = th_d_ic;              

%% define external force
external = zeros(N+1,len_th);
external(:,1) = 1*sin(t)';
external(:,2) = 1*cos(t)';
tic;
for i = 1:1:N
%% Generalized coordinates q = [alpha theta]^{T}
th1v = qn(i,1);
th2v = qn(i,2);

th1v_d = un(i,1);
th2v_d = un(i,2);

e1 = external(i,1);
e2 = external(i,2);

Mv = [m2*l1^2 + 2*m2*cos(th2v)*l1*lc2 + m1*lc1^2 + m2*lc2^2 + izz1 + izz2, izz2 + lc2*m2*(lc2 + l1*cos(th2v));
                                       izz2 + lc2*m2*(lc2 + l1*cos(th2v)),                    m2*lc2^2 + izz2];

hv = [l1*lc2*m2*sin(th2v)*th2v_d^2 + 2*l1*lc2*m2*th1v_d*sin(th2v)*th2v_d + e1 - g*lc2*m2*cos(th1v + th2v) - g*l1*m2*cos(th1v) - g*lc1*m1*cos(th1v);
                                                                                   - l1*lc2*m2*sin(th2v)*th1v_d^2 + e2 - g*lc2*m2*cos(th1v + th2v)];


un(i+1,:) = un(i,:) + ((Mv\(hv))*dt)';
qn(i+1,:) = qn(i,:) + un(i,:)*dt;

end

toc;

%% Plot non-linear result
%--------------RGB color-----------------
rgb =[230,230,250;...           %lavender
      176,196,222;...           %light steel blue
      112,128,144;...           %slate gray
      72,61,139;...             %dark slate blue
      105,105,105               %dim gray / dim grey
      ]./255; 
%----------------------------------------

figure(1);
subplot(2,1,1);
plot(t,qn(:,1),'color',rgb(3,:),'LineStyle','-'); %alpha(t)
hold on;
plot(t,qn(:,2),'color',rgb(4,:),'LineStyle',':'); %theta(t)
hold off;
L0=legend('$\theta_{1}$(t) [rad]','$\theta_{2}$(t) [rad]','Interpreter','Latex');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Response','Interpreter','Latex');
title('Lagrange','Interpreter','Latex');
% title({'Rotary inverted pendulum';['$\alpha$(t0)=',num2str(qn(1,1)),'[rad],','$\theta$(t0)=',num2str(qn(1,2)),'[rad],'];...
%       ['  $\dot{\alpha}$(t0)=',num2str(un(1,1)),'[rad/s],','$\dot{\theta}$(t0)=',num2str(un(1,2)),'[rad/s].']},'Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
subplot(2,1,2);
plot(t,un(:,1),'color',rgb(3,:),'LineStyle','-'); %alpha_dot(t)
hold on;
plot(t,un(:,2),'color',rgb(4,:),'LineStyle',':'); %theta_dot(t)
hold off;
L0=legend('$\dot{\theta}_{1}$(t) [rad/s]','$\dot{\theta}_{2}$(t) [rad/s]','Interpreter','Latex','Location','Northeast');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Velocity Response','Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
set(gcf,'position',[500 500 455 400]);
%% simulink theta
simuout = sim('ideal_double_pendulum',T);

figure(2);
subplot(2,1,1);
plot(simuout.q1.Time,simuout.q1.Data,'color',rgb(3,:),'LineStyle','-'); %alpha(t)
hold on;
plot(simuout.q2.Time,simuout.q2.Data,'color',rgb(4,:),'LineStyle',':'); %theta(t)
hold off;
L0=legend('$\theta_{1}$(t) [rad]','$\theta_{2}$(t) [rad]','Interpreter','Latex');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Response','Interpreter','Latex');
title('simulink','Interpreter','Latex');
% title({'Rotary inverted pendulum';['$\alpha$(t0)=',num2str(qn(1,1)),'[rad],','$\theta$(t0)=',num2str(qn(1,2)),'[rad],'];...
%       ['  $\dot{\alpha}$(t0)=',num2str(un(1,1)),'[rad/s],','$\dot{\theta}$(t0)=',num2str(un(1,2)),'[rad/s].']},'Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
subplot(2,1,2);
plot(simuout.w1.Time,simuout.w1.Data,'color',rgb(3,:),'LineStyle','-'); %alpha_dot(t)
hold on;
plot(simuout.w2.Time,simuout.w2.Data,'color',rgb(4,:),'LineStyle',':'); %theta_dot(t)
hold off;
L0=legend('$\dot{\theta}_{1}$(t) [rad/s]','$\dot{\theta}_{2}$(t) [rad/s]','Interpreter','Latex','Location','Northeast');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Velocity Response','Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
set(gcf,'position',[500 500 455 400]);

%% simulink xy
figure(3);
subplot(3,1,1);
plot(simuout.x.Time,simuout.x.Data,'color',rgb(3,:),'LineStyle','-'); %alpha(t)
hold on;
plot(simuout.y.Time,simuout.y.Data,'color',rgb(4,:),'LineStyle',':'); %theta(t)
hold off;
L0=legend('$x$(t) [m]','$y$(t) [m]','Interpreter','Latex');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Response','Interpreter','Latex');
title('simulink','Interpreter','Latex');
% title({'Rotary inverted pendulum';['$\alpha$(t0)=',num2str(qn(1,1)),'[rad],','$\theta$(t0)=',num2str(qn(1,2)),'[rad],'];...
%       ['  $\dot{\alpha}$(t0)=',num2str(un(1,1)),'[rad/s],','$\dot{\theta}$(t0)=',num2str(un(1,2)),'[rad/s].']},'Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
subplot(3,1,2);
plot(simuout.vx.Time,simuout.vx.Data,'color',rgb(3,:),'LineStyle','-'); %alpha_dot(t)
hold on;
plot(simuout.vy.Time,simuout.vy.Data,'color',rgb(4,:),'LineStyle',':'); %theta_dot(t)
hold off;
L0=legend('$vx$(t) [m/s]','$vy$(t) [m/s]','Interpreter','Latex','Location','Northeast');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Velocity Response','Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
subplot(3,1,3);
plot(simuout.ax.Time,simuout.ax.Data,'color',rgb(3,:),'LineStyle','-'); %alpha_dot(t)
hold on;
plot(simuout.ay.Time,simuout.ay.Data,'color',rgb(4,:),'LineStyle',':'); %theta_dot(t)
hold off;
L0=legend('$ax$(t) [m/s2]','$ay$(t) [m/s2]','Interpreter','Latex','Location','Northeast');
set(L0,'FontSize',10);
grid on;
xlabel('Time [s]','Interpreter','Latex');
ylabel('Velocity Response','Interpreter','Latex');
set(findall(gcf,'type','line'),'linewidth',1.5);
set(findall(gcf,'type','text'),'FontSize',10);
ax = gca;
ax.FontSize = 10;
ax.TickLabelInterpreter = 'latex';
xlim([0,10]);
set(gcf,'position',[500 50 455 900]);
