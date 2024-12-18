function [polesHz,modes,poles]=hmodes(k,h,m)
%HMODES:    Complex modes and poles of a hysteretic linear system
%        [polesHz,modes,poles]=hmodes(k,h,m)
%   polesHz=[ F1   Z1
%             F2   Z2      F= frequency in Hz.
%               ...        Z= equivalent viscous damping ratio.
%             FN   ZN]
%
%         Ask also help on        cmodes rmodes eig fe_eig stimat
%   EXAMPLE:
%
%m=diag([3 9]); k=diag((2*pi)^2*[10^2 50^2])*m; h=diag(2*[0.01 0.02])*k;
%[polesHz,modes,poles]=hmodes(k,h,m)
%
%  22/02/99   J. Molina

ndof=size(k,1);
[modes,poles]=eig(k+j*h,m);
poles=diag(poles);
[pdum,ind]=sort(abs(poles));
poles=poles(ind,:);
modes=modes(:,ind);
polesHz=[sqrt(real(poles))/2/pi  tan(angle(poles))];

return

ndof=size(k,1);
[modes,poles]=eig(k+j*h,-m);
poles=-sqrt(diag(poles));
[pdum,ind]=sort(abs(poles));
poles=poles(ind,:);
modes=modes(:,ind);
polesHz=[abs(poles)/2/pi  -cos(angle(poles))];

