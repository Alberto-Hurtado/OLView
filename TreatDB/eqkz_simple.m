function [k,z]=eqkz_simple(d,f,plotflag)
%EQKZ:    Equivalent stiffness and damping.
%           [k,z]=eqkz(d,f,plotflag)
%           For a given history of one cycle of displacement d and force
%           f of a sdof system, a linear equivalent stiffness k and
%           viscous damping ratio z are found. The cycle must start and end 
%           with a displacement close to zero.
%           plotflag=1     to have a plot of the cycle
%
%        Ask also help on:         eqkzhilb
%
%  Example:
%
%      K=1000, Z=0.05, Fr=10
%      t=[0:0.05:1]/Fr;
%      d=sin(2*pi*Fr*t);
%      f=K*(sin(2*pi*Fr*t)+2*Z*cos(2*pi*Fr*t));
%      [k,z]=eqkz_simple(d,f,1)
%
%  17/8/98  J. Molina

if nargin<3; plotflag=[]; end;
if isempty(plotflag); plotflag=0; end;

d=d(:); f=f(:);


if plotflag;
  figure;
  plot(d,f);
  legend('measures','location','best');
end;

N=length(d);
[dmax,imax]=max(d);
[dmin,imin]=min(d);
D=(dmax-dmin)/2;
D0=(dmax+dmin)/2;
if abs(d(1)-d(N))>D/5;
  warning('The given displacements may not represent a cycle');
end;
d=[d; d(1)]; f=[f; f(1)]; N=N+1;   %2012 Closes the loop

fav=conv(f,[0.5; 0.5]);
Eabs=sum(fav(2:N).*diff(d));
FDAMP=Eabs/pi/D;
% fd=FDAMP*sqrt(1-((d-D0)/D).^2);
fd=FDAMP*sqrt(max((1-((d-D0)/D).^2),0));   %2012
if imax<imin;
  fd=[fd(1:imax); -fd(imax+1:imin); fd(imin+1:N)];
else;
  fd=[-fd(1:imin); fd(imin+1:imax); -fd(imax+1:N)];
end;
fel=f-fd;
k=(sum(d.*fel)-sum(d)*sum(fel)/N)/(sum(d.*d)-sum(d)^2/N);
Eel=k*D^2/2;
z=Eabs/4/pi/Eel;

if plotflag;
  F0=(max(f)+min(f))/2;
  plot(d,f,d,F0+k.*(d-D0)+fd,d,F0+k.*(d-D0));
  legend('measures',sprintf('k=%.4g z=%.3g',k,z),'location','best');
end;

