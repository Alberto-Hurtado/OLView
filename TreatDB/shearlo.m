function shl=shearlo(restor)
%SHEARLO
%          SHL = SHEARLO(RESTOR)
%          Genarates shear loads from storey restoring forces of a building.
%          Every column of RESTOR  or SHL refer to a storey or level in 
%             ascending order.
%
%                shl=flipud(cumsum(flipud(restor')))'
%
%          Ask also help on         isdrift cumsum diff 
%
%    EXAMPLES:
%                     shearlo([1.1  1.0  1.3])
%                     sv(11:13,shearlo(gv(1:3)))
%
% 11/6/97  J. Molina

if size(restor,2)>1;
  shl=flipud(cumsum(flipud(restor')))';
else;
  shl=restor;
end;
