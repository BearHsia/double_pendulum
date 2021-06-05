clc;clear;close all;
%% Link length
syms l1 l2; %link1 length, link2 length, link1 center mass length, link2 center mass length
P0_1 = [0;0;0];
P1_2 = l1*[1;0;0];
P2_3 = l2*[1;0;0];

%% Rotation matrix
syms th1v th2v;
syms th1v_d th2v_d;
syms th1v_dd th2v_dd;

R0_1 = [cos(th1v),-sin(th1v),0;sin(th1v),cos(th1v),0;0,0,1];
R1_2 = [cos(th2v),-sin(th2v),0;sin(th2v),cos(th2v),0;0,0,1];
R2_3 = [1,0,0;0,1,0;0,0,1];
R1_0 = transpose(R0_1);
R2_1 = transpose(R1_2);
R3_2 = transpose(R2_3);
R0_3 = R0_1*R1_2*R2_3;

%% Position propagation
P1_3 = Pi_x(P1_2,R1_2,P2_3);
P0_3 = Pi_x(P0_1,R0_1,P1_3);
P0_3 = simplify(P0_3);
disp(P0_3);

%% Velocity propagation
W0_0 = [0;0;0];
W1_1 = Wi1_i1(R1_0,W0_0,th1v_d,[0;0;1]);
W2_2 = Wi1_i1(R2_1,W1_1,th2v_d,[0;0;1]);

V0_0 = [0;0;0];
V1_1 = Vi1_i1(P0_1,R1_0,V0_0,W0_0);
V2_2 = Vi1_i1(P1_2,R2_1,V1_1,W1_1);
V3_3 = Vi1_i1(P2_3,R3_2,V2_2,W2_2);
V0_3 = simplify(R0_3*V3_3);
disp(V0_3);
%%
O0_0 = [0;0;0];
O1_1 = Oi1_i1(R1_0,W0_0,O0_0,[0;0;1],th1v_d,th1v_dd);
O2_2 = Oi1_i1(R2_1,W1_1,O1_1,[0;0;1],th2v_d,th2v_dd);
O3_3 = Oi1_i1(R3_2,W2_2,O2_2,[0;0;1],0,0);

A0_0 = [0;0;0];
A1_1 = Ai1_i1(P0_1,R1_0,W0_0,O0_0,A0_0);
A2_2 = Ai1_i1(P1_2,R2_1,W1_1,O1_1,A1_1);
A3_3 = Ai1_i1(P2_3,R3_2,W2_2,O2_2,A2_2);
A0_3 = simplify(R0_3*A3_3);
disp(A0_3);