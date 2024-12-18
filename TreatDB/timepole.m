function [polesHz,modes,poles]=timepole(x,u,time_increment,order)
%TIMEPOLE:   Time-domain identification of poles and modes.
%    [polesHz,modes,poles]=timepole(x,u,time_increment,order)
%       Identifies NDOF*order poles in the discrete-time
%       free or forced response
%       of a system with NDOF degrees of freedom.
%       Every column of x(NTIMES,NDOF) corresponds to one
%       degree of freedom and every column of u(NTIMES,NEXC) corresponds
%       to one excitation variable. Use u=zeros(NTIMES,0) for the case
%       of free response.
%       'time_increment' is the sampling period for the NTIMES samples
%       of x and u.
%       The 'order' of the adjusted model should be equal or greater than 
%       the order of the pysical system. For a system governed by a
%       second-order dynamic equation, use 'order'>=2.
%     
%   polesHz=[ F1   Z1
%             F2   Z2      F= frequency in Hz.
%               ...        Z= damping ratio.
%             FN   ZN]
%
%          Ask also help on   oemodel freepol autreg2 
%
%    EXAMPLES:
%
%f=5; z=0.08; dt=0.01; order=2; nt=8;
%u=rand(nt,1);
%x=sdofresp(u,dt,f,z);
%[polesHz]=timepole(x,u,dt,order)
%
%f1=5; f2=8; z=0.08; dt=0.01; order=2; nt=10;
%u=rand(nt,1);
%x=sdofresp(u,dt,[f1 f2],z);
%[polesHz,modes]=timepole(x,u,dt,order)
%
%f1=5; f2=8; z1=0.05; z2=0.08; dt=0.01; order=2; nt=7;
%t=dt*[1:nt]';
%x=[exp(-z1*f1*2*pi*t).*sin(2*pi*f1*t) exp(-z2*f2*2*pi*t).*sin(2*pi*f2*t)];
%u=zeros(nt,0);
%[polesHz,modes]=timepole(x,u,dt,order)
%
% 12/12/98   J. Molina

ndof=size(x,2);
Na=order; Nb=order;
[A1,B,A0]=oemodel(x,u,Na,Nb);
A=[A1 zeros(ndof*Na,ndof*(Na-1))]; I=eye(ndof);
for i=1:Na-1;
  A(ndof*(i-1)+[1:ndof],ndof*i+[1:ndof])=I;
end;


[modes,d]=eig(A');
poles=log(diag(d))/time_increment;
%[pdum,ind]=sort(abs(poles));
          R=real(poles)*3;
          I=imag(poles);
          [pdum,ind]=sort((R.*R+I.*I)./(2*abs(I)+1e-30));
poles=poles(ind,:);
%modes=modes(1:ndof,ind);
modes=modes(:,ind);
[pdum,ind]=sort(-sign(imag(poles)));
poles=poles(ind,:);
modes=modes(:,ind);
%i1=find(abs(imag(s))>100*eps);%i2=find(~(abs(imag(s))>100*eps));
%s=[s(i1); s(i2)];
polesHz=[abs(poles)/2/pi  -cos(angle(poles))];

for imode=1:size(modes,2)   % 2008 01 25
    [dum,jmax]=max(modes(:,imode));
    modes(:,imode)=modes(:,imode)./modes(jmax,imode);
end

return

