function [A,Jx,Jy,Wx,Wy,ix,iy]=isection(h,b,a,e,r)
%ISECTION:     Static parameters of an "I" section.
%       [A,Jx,Jy,Wx,Wy,ix,iy]=isection(h,b,a,e,r)
%
%             EXAMPLES:
%  [A,Jx,Jy,Wx,Wy,ix,iy]= ...
%       isection(0.290,0.268,0.018,0.0325,0.024)   %HE260M
%  [A,Jx,Jy,Wx,Wy,ix,iy]= ...
%       isection(0.600,0.220,0.012,0.019,0.024)   %IPE600
%
% 22/9/97  J. Molina

h1=h-2*e;
b1=b-a;
ar=(4-pi)*r^2;
r1=(10-3*pi)/3/(4-pi)*r;
A=b*h-b1*h1+ar;
Jx=(b*h^3-b1*h1^3)/12+ar*(h1/2-r1)^2;
Jy=(2*e*b^3+h1*a^3)/12+ar*r1^2;
Wx=Jx/h*2;
Wy=Jy/b*2;
ix=sqrt(Jx/A);
iy=sqrt(Jy/A);
