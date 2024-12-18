function [d,v,a,t,f,delt,DD,VV,AA,TT]=expnewmark(f1,k,c,m,delt1,dinit,vinit,ainit,nInterp)
% Explicit Newmark integration of linear system with subdivision of the
% original time increment
%      f1(np1,NDoF) k(NDoF,NDoF) c(NDoF,NDoF) m(NDoF,NDoF)

NDoF=size(f1,2);
np1=size(f1,1); %original number of samplings
time1=[0:np1-1]'*delt1; %original time
% if nInterp>1    %excitation is linearly interpolated dividing time increment by nInterp
delt=delt1/nInterp; %final time increment
% NT=nInterp*np1+1; %FINAL NUMBER OF SAMPLINGS
NT=nInterp*np1; %FINAL NUMBER OF SAMPLINGS  % 2023
t=[0:NT-1]'*delt;
f = interp1(time1,f1,t,'linear');

d=zeros(NT,NDoF);v=d;a=d;

T=1;
d(T,:)=dinit;
a(T,:)=ainit;
v(T,:)=vinit+delt*0.5*a(T,:);

% a(T,:)=(inv(m)*(f(T,:)'-k*d(T,:)'-c*v(T,:)'))';
d(T+1,:)=d(T,:)+delt*(v(T,:)+delt*0.5*a(T,:));
m1inv=inv(m+0.5*delt*c);
for T=2:NT
    vExplT=v(T-1,:)+0.5*delt*a(T-1,:);
    a(T,:)=(m1inv*(f(T,:)'-k*d(T,:)'-c*vExplT'))';
    v(T,:)=v(T-1,:)+0.5*delt*(a(T-1,:)+a(T,:));
    if T<NT
        d(T+1,:)=d(T,:)+delt*(v(T,:)+delt*0.5*a(T,:));
    end
end

% 2023
DD=d(1:nInterp:NT,:);
VV=v(1:nInterp:NT,:);
AA=a(1:nInterp:NT,:);
TT=t(1:nInterp:NT,1);

return
