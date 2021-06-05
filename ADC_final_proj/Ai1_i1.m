function res = Ai1_i1(Pi_i1,Ri1_i,Wi_i,Oi_i,Ai_i)
%AI1_I1 Summary of this function goes here
%   Detailed explanation goes here
res = Ri1_i*(cross(Oi_i,Pi_i1)+cross(Wi_i,cross(Wi_i,Pi_i1))+Ai_i);
end

