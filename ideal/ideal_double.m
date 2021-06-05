clc;clear;close all;

syms t; %time
%% Inertia
syms ixx1 iyy1 izz1 ixx2 iyy2 izz2 m1 m2 g;
I1 = [ixx1,0,0;0,iyy1,0;0,0,izz1];
I2 = [ixx2,0,0;0,iyy2,0;0,0,izz2];

%% External force
syms e1 e2;
Ef = [e1;e2];
%% Dissipation force
%syms q1 q2;
%Qd = [q1;q2];
%% Link length
syms l1 l2 lc1 lc2; %link1 length, link2 length, link1 center mass length, link2 center mass length

%% Rotation matrix
syms th1v th2v;
syms th1v_d th2v_d;
syms th1f(t) th2f(t);
th1f_d(t) = diff(th1f,t);
th2f_d(t) = diff(th2f,t);

R0_1 = [cos(th1f),-sin(th1f),0;sin(th1f),cos(th1f),0;0,0,1];
R1_2 = [cos(th2f),-sin(th2f),0;sin(th2f),cos(th2f),0;0,0,1];
R1_0 = transpose(R0_1);
R2_1 = transpose(R1_2);

%% Coordinates
Xi_i = [1;0;0];
Yi_i = [0;1;0];
Zi_i = [0;0;1];

%% Velocity
W1_1 = th1f_d*Zi_i
W2_2 = R2_1*W1_1+th2f_d*Zi_i
V1_1 = 0; %at the root of link1 (rotation joint of link0 and link1)
V2_2 = R2_1*(V1_1 + cross(W1_1,l1*Xi_i));
Vc1 = V1_1 + cross(W1_1,lc1*Xi_i);
Vc2 = V2_2 + cross(W2_2,lc2*Xi_i);

%% Kinematic energy
k1 = sym(1/2)*m1*transpose(Vc1)*Vc1 + sym(1/2)*transpose(W1_1)*I1*W1_1;
k2 = sym(1/2)*m2*transpose(Vc2)*Vc2 + sym(1/2)*transpose(W2_2)*I2*W2_2;
Kf = k1 + k2;
Kv = subs(Kf,{th1f, th2f, th1f_d, th2f_d},{th1v, th2v, th1v_d, th2v_d});

%% Potential energy
u1 = m1*g*lc1*sin(th1f);
u2 = m2*g*(l1*sin(th1f) + lc2*sin(th1f+th2f));
Uf = u1+u2;
Uv  = subs(Uf,{th1f, th2f, th1f_d, th2f_d},{th1v, th2v, th1v_d, th2v_d});

%% Mass function
Mv1=[diff(Kv,th1v_d);diff(Kv,th2v_d)];
Mv =simplify([diff(Mv1,th1v_d) diff(Mv1,th2v_d)]);

%% H function
h1 = [diff(Kv,th1v);diff(Kv,th2v)]; %(dTf/dq)'
h2 = [diff(Uv,th1v);diff(Uv,th2v)]; %(dVf/dq)'
h3_tmp = [diff(Kv,th1v_d);diff(Kv,th2v_d)];
uv = [th1v_d;th2v_d];
h3 = [diff(h3_tmp,th1v) diff(h3_tmp,th2v)]*uv;  %(ddTf/dudq)'*u
%hv = simplify(-Qd+h1-h2-h3);
hv = simplify(h1-h2-h3+Ef);

%% display
disp("-----------------")
disp(Mv);
disp("-----------------")
disp(hv);