function res = Vi1_i1(Pi_i1,Ri1_i,Vi_i,Wi_i)
%VI1_I1 Summary of this function goes here
%   Detailed explanation goes here
res = Ri1_i*(Vi_i+cross(Wi_i,Pi_i1));
end

