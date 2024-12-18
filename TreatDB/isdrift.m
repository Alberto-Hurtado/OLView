function isd=isdrift(disp)
%ISDRIFT
%          ISD = ISDRIFT(DISP)
%          Genarates inter-storey drifts from storey displacements of a building.
%          Every column of DISP  or ISD refer to a storey or level in 
%             ascending order.
%
%             isd=diff([zeros(size(disp,1),1) disp]')'   
%
%          Ask also help on         shearlo diff cumsum
%
%    EXAMPLES:
%                     isdrift([.2 .6 .8])
%                     sv(11:13,isdrift(gv(1:3)))
%
% 11/6/97  J. Molina

isd=diff([zeros(size(disp,1),1) disp]')';
