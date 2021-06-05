function res = Oi1_i1(Ri1_i,Wi_i,Oi_i,AXISi1_i1,Si1_d,Si1_dd)
%OI1_I1 Summary of this function goes here
%   Detailed explanation goes here
res = Ri1_i*Oi_i + cross(Ri1_i*Wi_i,Si1_d*AXISi1_i1) + Si1_dd*AXISi1_i1;
end

