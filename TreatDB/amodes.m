function [polesHz,modes,poles,ganma]=amodes(k,c,m,j)
%AMODES:    Complex modes and poles of a linear system for asymetric matrix
%        [polesHz,modes,poles,ganma]=cmodes(k,c,m,j)
%   polesHz=[ F1   Z1
%             F2   Z2      F= frequency in Hz.
%               ...        Z= damping ratio.
%             FN   ZN]
%
%         Ask also help on        cmodes rmodes eig fe_eig stimat
%   EXAMPLE:
%
%m=diag([3 9]); k=[2 3;6 9]; c=[1 2;3 1];j=ones(2,1)
%[polesHz,modes,poles,ganma]=amodes(k,c,m,j)
%
%  3/12/99   J. Molina & Placeres G.

ndof=size(k,1);

if nargin<4
   j=ones(ndof,1);
end

zz=zeros(ndof);
a=[c m; m zz];
b=[k zz;zz -m];
[modes,poles]=eig(b,-a);
poles=diag(poles);
[pdum,ind]=sort(abs(poles));
poles=poles(ind,:); 
modes=modes(:,ind);
[pdum,ind]=sort(-sign(imag(poles)));   
poles=poles(ind,:);
modes=modes(:,ind);  
polesHz=[abs(poles)/2/pi  -cos(angle(poles))];

imodes=inv(modes);
m0=[j;zeros(ndof,1)];
ganma=zeros(ndof,1);

for ii=1:ndof
   ganma(ii)=imodes(ii,:)*inv(a)*m0;
end

